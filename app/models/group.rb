class Group < ActiveRecord::Base

  ##associations
  belongs_to :admin, class_name: "User", foreign_key: "user_id"
  has_and_belongs_to_many :users, :dependent => :destroy

  ##for error masseges
  def display_errors
    self.errors.full_messages.join(', ')
  end
end