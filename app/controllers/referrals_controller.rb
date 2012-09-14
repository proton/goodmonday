# coding: utf-8

class ReferralsController < ApplicationController

	def show
    if params[:id] && !params[:id].empty?
      referral_id = params[:id]
      referral = User.where(:_id => referral_id).first
      cookies[:referral] = referral_id if referral
    end
    redirect_to root_url
	end
end
