# coding: utf-8

class Admin::ProfilesController < Admin::BaseController
	respond_to :html

  before_filter :find_profile

  def show
    add_crumb "Пользователи", users_path
    add_crumb "Пользователь «#{@user.email}»", user_path(@user)
    add_crumb "Профиль"
  end

  def update
    profile_params = params[:webmaster_profile] ? params[:webmaster_profile] : params[:advertiser_profile]
    flash[:notice] = 'Профиль обновлён.' if @profile.update_attributes(profile_params)
    respond_with(@profile, :location => user_profile_path(@user))
  end

	protected

	def find_profile
    @user = User.find(params[:user_id])
    case @user.class
      when Webmaster
        @profile = @user.webmaster_profile
        @profile = @user.create_webmaster_profile if @profile.nil?
      when Advertiser
        @profile = @user.advertiser_profile
        @profile = @user.create_advertiser_profile if @profile.nil?
    end
  end
end
