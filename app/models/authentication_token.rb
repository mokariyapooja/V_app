class AuthenticationToken < ActiveRecord::Base
  
  ##callbacks
  before_create :generate_token
  
  ##associations
  belongs_to :user
  
  private
  def generate_token  
    token   = SecureRandom.hex
      while AuthenticationToken.find_by(auth_token: token )
        token = SecureRandom.hex
      end
    self.auth_token = token
  end 
end