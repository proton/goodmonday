class My::RegistrationsController < Devise::RegistrationsController
	before_filter :find_affiliation

	def find_affiliation
		if params[:referral] && !params[:referral].empty?
			referral_id = params[:referral]
			referral = User.where(:_id => referral_id).first
			cookies[:referral] = referral_id if referral
		end
		if cookies[:referral] && !cookies[:referral].empty?
			@affiliator_id = cookies[:referral]
      @affiliator = Member.where(:_id => @affiliator_id).first
      @affiliator.inc(:referal_count, 1) if @affiliator
		end
  end

  def create
    #copied from https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb
    user_params = params[:user]
    user_type = user_params[:_type]
    user_type = 'Webmaster' unless ['Webmaster', 'Advertiser'].include? user_type
    self.resource = user_type.constantize.new_with_session(user_params, session)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def after_sign_up_path_for(resource)
    root_url(:subdomain => 'my')
  end
end