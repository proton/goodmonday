# coding: utf-8

class My::GroundAdvertOffersController < My::BaseController
	inherit_resources
	before_filter :find_ground

	def find_ground
		@ground = current_user.grounds.find(params[:ground_id])
	end

	def index
		@state = (params[:state]) ? params[:state].to_sym : :accepted
		case @state
			when :accepted
				@offers = Offer.find(@ground.accepted_rotator_offers_ids)
			when :denied
				@offers = Offer.find(@ground.denied_rotator_offers_ids)
			when :pending
				@offers = Offer.find(@ground.pending_rotator_offers_ids)
		end
	end

	def new
		@offers = Offer.accepted.not_in(_id: @ground.advert_offers_ids)
	end

	def create
		@offer = Offer.find(params[:offer_id])
		flash[:notice] = 'Оффер добавлен.' if @ground.add_advert_offer_and_save(@offer)
		redirect_to my_ground_adverts_path(@ground)
	end

	def destroy
		@offer = Offer.find(params[:id])
		flash[:notice] = 'Оффер удалён.' if @ground.remove_advert_offer_and_save(@offer)
		redirect_to my_ground_adverts_path(@ground)
 	end

end
