# coding: utf-8

class Admin::BaseController < ApplicationController
	respond_to :html
	before_filter :authenticate_operator!

	add_crumb 'Панель адмнинистрирования', '/admin'

	def index
		#case current_user.class
		#	when Advertiser
		#		@offers = current_user.offers
		#	when Webmaster
		#		@grounds = current_user.grounds
		#end
	end
end
