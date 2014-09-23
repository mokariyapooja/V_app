class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  reverse_geocoded_by :latitude, :longitude

  ##call_backs
  after_create :create_notification
  after_update :send_notification_user, :if => :latitude_changed? && :longitude_changed?

  ##associations
  has_many :authentication_tokens, :dependent => :destroy
  has_many :notification, :dependent => :destroy
  has_and_belongs_to_many :groups, :dependent => :destroy
  has_many :maneged_groups, class_name: "Group", foreign_key: "user_id", :dependent => :destroy
  
  ##validations
  validates_uniqueness_of :mobile_number
  validates_format_of :mobile_number, 
                      :with => /\A[0-9]{10,15}\Z/,:maximum =>15,:minimum =>10

  ##class
  class << self
    def authenticate_user_with_auth_token(mobile_number,password)
      return nil unless  mobile_number.present? or password.present?
     Rails.logger.debug "===========#{ mobile_number or password}============"
        u = User.find_by_mobile_number(mobile_number)
          Rails.logger.debug "===========#{ u }============"
       (u.present? && u.valid_password?(password)) ? u : nil    
    end 
  end

  def send_notification_user
    list = []
    Rails.logger.debug "===========arrey list nil #{ list.inspect }============"
    @near_by_users = self.nearbys(0.300, :units => :km)
    Rails.logger.debug "===========nearbys #{ @near_by_users.inspect }============"
    near_by_users_ids = []
    Rails.logger.debug "===========arrey near_by_users_ids nil #{ near_by_users_ids.inspect }============"
    if @near_by_users.present?
      @near_by_users.each do |user|
        near_by_users_ids << user.id
        Rails.logger.debug "===========nearbys_user_ids.present#{ near_by_users_ids.inspect }============"
        Rails.logger.debug "===========user list #{ list.inspect }============"
        @notify = Notification.where("sender_id in (?) and resever_id in (?)" ,[self.id , user.id],[self.id , user.id])
        Rails.logger.debug "===========notify #{ @notify.inspect }============"
        if !(@notify.last.in_range)
          list << user.first_name
          Rails.logger.debug "===========list user first_name #{ list.inspect }============"
          @notify.first.update_attributes(in_range: true)
          Rails.logger.debug "===========User#{ user.inspect }============"
          user.send_notification("#{self.first_name} in your area")                            
        end
      end
      other_users = User.where("id not in (?)",near_by_users_ids).pluck("id") 
    end
    other_users = User.pluck("id") unless other_users.present?   
    Rails.logger.debug "=========== other User#{ other_users.inspect }============"           
    @other_users_notification = Notification.where("sender_id in (?) and resever_id in (?)",other_users,other_users)
    Rails.logger.debug "=========== other notification User#{  @other_users_notification.inspect }============"
    @other_users_notification.update_all(in_range: false) if other_users_notification.present?
    self.send_notification("#{list.join(" ,")} in your area") 
    Rails.logger.debug "===========#{ list.join(" ,").inspect }============"
  end
  
  ##create_notification
  def create_notification
   Rails.logger.debug "===========#{ id.inspect }============"
    User.where("id != ?" , self.id).each do |user|
       Rails.logger.debug "===========#{ user.inspect }============"
      @notification = Notification.create(sender_id:self.id, resever_id: user.id)
        Rails.logger.debug "===========#{ @notification.inspect }============"
      @notification.save
    end
  end
 
  def has_android_devise?
    devise_type.downcase == "android"
  end

  def has_iphone_devise?
    devise_type.downcase == "iphone"
  end
 
 ##send notification
 def send_notification(msg)
    if self.devise_id?
      if self.has_android_devise?
        GCM.key = "AIzaSyAETxyIUZrrtjpmJ57b1jkUW7C_bo97mJU"
        GCM.send_notification(self.devise_id, {:message => msg}, :time_to_live => 3600)
        puts "android"
      elsif self.has_iphone_devise?  
        APNS.port ='2195'
        APNS.pem  = "#{Rails.root}/config/vicinityCert.pem"
        APNS.host = 'gateway.sandbox.push.apple.com'
        APNS.pass = '1234'
        APNS.send_notification(self.devise_id, :alert => msg, :badge => 1, :sound => 'default')
        puts "iphone"
      end
    end
  end

  ##for error masseges
  def display_errors
    self.errors.full_messages.join(', ')
  end
end