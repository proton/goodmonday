# coding: utf-8

class ReferralsController < ApplicationController

  def index
    if params[:referral] && !params[:referral].empty?
      referral_id = params[:referral]
      referral = User.where(:_id => referral_id).first
      cookies[:referral] = referral_id if referral
    end
    redirect_to root_url
  end

	def show
    if params[:id] && !params[:id].empty?
      referral_id = params[:id]
      referral = User.where(:_id => referral_id).first
      cookies[:referral] = referral_id if referral
    end
    redirect_to root_url
	end
end
