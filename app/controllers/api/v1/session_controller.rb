class Api::V1::SessionController < Api::V1::BaseController
 
##Filter
before_action :define_current_user, only: [:sing_out, :change_password]

  ##sing_up
  def sing_up 
    @user = User.new(users_params)
    #puts  "===========#{@user.inspect}============"
    Rails.logger.debug "===========#{@user.inspect}============"
    if @user.save
      @token = @user.authentication_tokens.build
      @token.save
     #puts  "===========#{@token.inspect}==========="
     logger.warn("===========#{@token.inspect}============")
      Rails.logger.debug "===========#{@token.inspect}============"
    else
      render_json(:errors => @user.display_errors, :status => 404)       
    end   
  end

  ##sing_in
  def sing_in
    @valid_mobile_number = params[:mobile_number].present?
    @valid_password = params[:password].present?
    @user = User.authenticate_user_with_auth_token(params[:mobile_number],params[:password])
    logger.warn("===========#{@token.inspect}============")
    logger.warn("===========#{@user.inspect}============")
    Rails.logger.debug "===========#{@user.inspect}============"
    if @user.present?
      @token = @user.authentication_tokens.build
      @token.save
      logger.warn("===========#{@user.inspect}============")
      Rails.logger.debug "===========#{@token.inspect}============"
      render :file => 'api/v1/session/register'   
    elsif !@valid_password && !@valid_mobile_number
      render_json({:errors => "Email and password is required",:status => 404}.to_json)  
    else
      render_json({:errors => User.invalid_credential, :status => 404}.to_json)
    end
  end

  ##sing_out
  def sing_out
    logger.warn("===================#{params[:auth_token]}")
    #Rails.logger.debug "===========#{@token.inspect}============"
    if @token.present?
      Rails.logger.debug "===========#{@token.inspect}============"
      @token.destroy      
      Rails.logger.debug "===========#{@token.inspect}============"
      render_json({:message => "Logout Successfully!"}.to_json)
    else
      render_json({:errors => "No user found with authentication_token = #{params[:authentication_token]}"}.to_json)
    end
  end

  ##forgot_password
  def forgot_password
  if params[:mobile_number].present?
      @user = User.find_by(mobile_number: params[:mobile_number])
      if @user.present?
        @user.send_reset_password_instructions
        render_json({:message => "You will receive an email with instructions about how to reset your password in a few minutes.", :status => 200}.to_json)
      else
        render_json({:errors => "No User found with email #{params[:mobile_number]}", :status => 404}.to_json)
      end
    else
      render_json({:errors => "Mobile Nunber is required", :status => 404}.to_json)
    end 
  end
  
  ##change_password
  def change_password
    if params[:user][:current_password].present? && params[:user][:password].present?
      if @user.update_with_password(change_password_params)
        Rails.logger.debug "===========#{@user.inspect}============"
        render_json({:message => "Your Password Successfully updated", :status => 200}.to_json)
      else
        render_json({:errors => @user.display_errors, :status => 404}.to_json)
      end
    else
      render_json({:errors => "Current Password and Password required", :status => 404}.to_json)
    end
  end

  private
  def users_params
    params.require(:user).permit(:email,:password,:password_confirmation,:first_name,:last_name,:mobile_number,:device_id,:device_type)
  end

  def change_password_params
    params.require(:user).permit(:current_password,:password,:password_confirmation)
  end
end