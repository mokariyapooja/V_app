class Api::V1::UserController < Api::V1::BaseController
   
##Filter
before_action :define_current_user

  def update_profile
    if @user.update_attributes(update_params)
      render_json({:message => "your profile is updated" , :status => 200}).to_json   
    else
      render_json(:errors => @user.display_errors, :status => 404)
    end
  end

  def update_latitude_longitude 
   if params[:user][:latitude].present? && params[:user][:longitude].present?
      @user_location = @user.update_attributes(update_latitude_longitude_params)
      if @user_location.present?
        render_json({:message => "Location Successfully updated", :status => 200}.to_json)
      else
        render_json({:errors => @user.display_errors, :status => 404}.to_json)
      end
    else
      render_json({:errors => "Latitude and Longitude are required", :status => 404}.to_json)
    end
  end
 
  private
  def update_params
    params.require(:user).permit(:email, :first_name,:last_name)
  end
  def update_latitude_longitude_params
    params.require(:user).permit(:latitude ,:longitude)
  end
end