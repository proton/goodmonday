# coding: utf-8

class Admin::DebtorsController < Admin::BaseController

	def index
		@users = Advertiser.all
		add_crumb "Должники"
	end
end
