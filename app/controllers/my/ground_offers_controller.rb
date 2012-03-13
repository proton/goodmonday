# coding: utf-8

class My::GroundOffersController < My::BaseController
	inherit_resources
	belongs_to :offer

	def index
		@offer = current_user.offers.find(params[:offer_id])
		@ground_offers = @offer.ground_offers
	end

	def accept
		@offer = current_user.offers.find(params[:offer_id])
		@ground_offer = @offer.ground_offers.find(:ground_id)
		@ground_offer.state = :accepted
		@ground_offer.save
		redirect_to my_offer_grounds(@offer)
	end

	def deny
		@offer = current_user.offers.find(params[:offer_id])
		@ground_offer = @offer.ground_offers.find(:ground_id)
		@ground_offer.state = :denied
		@ground_offer.save
		redirect_to my_offer_grounds(@offer)
	end

end
