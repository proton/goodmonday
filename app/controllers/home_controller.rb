class HomeController < ApplicationController
	before_filter :find_affiliation

	def find_affiliation
		if params[:referral] && !params[:referral].empty?
			referral_id = params[:referral]
			referral = User.where(:_id => referral_id).first
			cookies[:referral] = referral_id if referral
		end
	end
end