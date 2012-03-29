# coding: utf-8

class My::GroundLinkOffersController < My::BaseController
	inherit_resources
	before_filter :find_ground

	def find_ground
		@ground = current_user.grounds.find(params[:ground_id])
	end

	def index
		@state = (params[:state]) ? params[:state].to_sym : :accepted
		case @state
			when :accepted
				@offers = Offer.find(@ground.accepted_link_offers_ids)
			when :denied
				@offers = Offer.find(@ground.denied_link_offers_ids)
			when :pending
				@offers = Offer.find(@ground.pending_link_offers_ids)
		end
	end

	def new
		@offers = Offer.accepted.not_in(_id: @ground.link_offers_ids)
	end

	def create
		@offer = Offer.find(params[:offer_id])

		respond_to do |format|
			if @ground.add_link_offer_and_save(@offer)
				format.html  { redirect_to(my_ground_links_path(@ground), :notice => 'Оффер добавлен.') }
			else
				format.html  { redirect_to my_ground_links_path(@ground) }
			end
		end
	end

	def destroy
		@offer = Offer.find(params[:id])
		@ground.remove_link_offer_and_save(@offer)
		redirect_to my_ground_links_path(@ground)
 	end

end
