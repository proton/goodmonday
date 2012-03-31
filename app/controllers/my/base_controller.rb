# coding: utf-8

class My::BaseController < ApplicationController
	respond_to :html
	inherit_resources
	before_filter :authenticate_user!

	def index
		case current_user.class
			when Advertiser
				@offers = current_user.offers
			when Webmaster
				@grounds = current_user.grounds
		end
	end
end
