# coding: utf-8

class My::GroundOffersController < My::BaseController
	inherit_resources
	before_filter :find_offer

	def find_offer
		@offer = current_user.offers.find(params[:offer_id])
	end

	def index
		@ground_offers = @offer.ground_offers
	end

	def accept
		@ground_offer = @offer.ground_offers.find(params[:ground_id])
		@ground_offer.state = :accepted
		@ground_offer.save
		redirect_to my_offer_grounds_path(@offer)
	end

	def deny
		@ground_offer = @offer.ground_offers.find(params[:ground_id])
		@ground_offer.state = :denied
		@ground_offer.save
		redirect_to my_offer_grounds_path(@offer)
	end

end
