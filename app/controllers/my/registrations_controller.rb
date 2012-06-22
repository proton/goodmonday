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

  def after_sign_up_path_for(resource)
    root_url(:subdomain => 'my')
  end
end