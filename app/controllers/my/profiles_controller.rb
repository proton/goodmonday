# coding: utf-8

class My::ProfilesController < My::BaseController
	respond_to :html

  before_filter :find_profile

  def update
    profile_params = params[:webmaster_profile].merge(params[:webmaster_profile])
    flash[:notice] = 'Статья обновлена.' if @profile.update_attributes(profile_params)
    respond_with(@profile, :location => profile_path)
  end

	protected

	def find_profile
    case current_user.class
      when Webmaster
        @profile = current_user.webmaster_profile
        @profile = current_user.create_webmaster_profile if @profile.nil?
      when Advertiser
        current_user.advertiser_profile
        @profile = current_user.create_advertiser_profile if @profile.nil?
    end
  end
end
