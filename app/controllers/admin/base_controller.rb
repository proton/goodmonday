# coding: utf-8

class Admin::BaseController < ApplicationController
	inherit_resources
	before_filter :authenticate_operator!

	def index
		#case current_user.class
		#	when Advertiser
		#		@offers = current_user.offers
		#	when Webmaster
		#		@grounds = current_user.grounds
		#end
	end
end
