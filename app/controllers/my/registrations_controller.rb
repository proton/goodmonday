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
		end
	end
end