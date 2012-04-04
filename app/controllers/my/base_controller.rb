# coding: utf-8

class My::BaseController < ApplicationController
	respond_to :html
	before_filter :authenticate_user!

	add_crumb 'Кабинет', '/my'

	def index
		case current_user.class
			when Advertiser
				@offers = current_user.offers
			when Webmaster
				@grounds = current_user.grounds
		end
	end

	protected

	def forbid
		render :status => :forbidden, :text => "Forbidden access"
	end
end
