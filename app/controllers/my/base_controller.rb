# coding: utf-8

class My::BaseController < ApplicationController
	respond_to :html
	before_filter :authenticate_user!
	before_filter :get_user_status
	layout 'my'

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

	def get_user_status
		@is_operator = (current_user.class==Operator)
	end
end
