# coding: utf-8

class My::BaseOperatorController < My::BaseController
	respond_to :html
	before_filter :authenticate_operator

	protected

	def authenticate_operator
		redirect_to my_path unless @is_operator
	end
end
