class Api::V1::GroupController <  Api::V1::BaseController
  
##Filter
before_action :define_current_user

  def create_group
    @group = @user.maneged_groups.build(groups_params) 
     Rails.logger.debug "===========#{@group.inspect}============"
    if @group.save
       Rails.logger.debug "===========#{@group.inspect}============"
      render :file => 'api/v1/group/show'            
    else
      render_json(:errors => @user.display_errors, :status => 404) 
    end
  end

  def add_friends_in_group
    if params[:group_id].present? && params[:user_ids].present?
      @group = Group.find(params[:group_id])
      Rails.logger.debug "===========#{@group.inspect}============"
      if @group.present?
        @users = User.where(:id => params[:user_ids].split(","))
        Rails.logger.debug "===========#{@users.inspect}============"
        @group.users << @users 
        Rails.logger.debug "===========#{@group.users.inspect}============"
        render_json(:messege => "User succesfully added", :status => 404)
      else
        render_json({:errors => "No group found", :status => 404}.to_json)
      end 
    else
      render_json({:errors => "group_id and user_ids are required", :status => 404}.to_json)
    end
  end

  def groups_list
    Rails.logger.debug "===========#{ @maneged_groups.inspect}============"
    @maneged_groups = @user.maneged_groups
    @groups = @user.groups
    if @maneged_groups.present? || @groups.present?
      Rails.logger.debug "===========#{ @maneged_groups.inspect}============"
      render :file => 'api/v1/group/index'
    else
      render_json({:errors => "No groups yet.!", :status => 404}.to_json)
    end 
  end

  private
  def groups_params
    params.require(:group).permit(:group_name)
  end
end