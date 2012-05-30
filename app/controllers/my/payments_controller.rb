# coding: utf-8

class My::PaymentsController < My::BaseController
	before_filter :and_crumbs

	def index
		@payments = current_user.payments
	end

	def and_crumbs
		add_crumb "Платежи", payments_path
	end

end
