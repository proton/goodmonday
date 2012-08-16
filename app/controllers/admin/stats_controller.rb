# coding: utf-8

class Admin::StatsController < Admin::BaseController

	def index
		add_crumb "Статистика"

    @offers = Offer.all
	end
	
end
