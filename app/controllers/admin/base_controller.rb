# coding: utf-8

class Admin::BaseController < My::BaseController
	respond_to :html
	before_filter :authenticate_operator

	protected

	def authenticate_operator
		redirect_to root_url(:subdomain => :my) unless @is_operator #TODO: rewrite for 403
	end

end
