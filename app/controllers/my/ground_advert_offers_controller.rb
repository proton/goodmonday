# coding: utf-8

class My::GroundAdvertOffersController < My::BaseController
	before_filter :find_nested_objects
	before_filter :and_nested_crumbs

	def index
		@state = (params[:state]) ? params[:state].to_sym : :accepted
		case @state
			when :accepted
				@offers = Offer.find(@ground.accepted_rotator_offers_ids)
				add_crumb 'Одобренные офферы'
			when :denied
				@offers = Offer.find(@ground.denied_rotator_offers_ids)
				add_crumb 'Отвергнутые офферы'
			when :pending
				@offers = Offer.find(@ground.pending_rotator_offers_ids)
				add_crumb 'Ожидающие одобрения офферы'
		end
	end

	def new
		add_crumb 'Новый оффер'
		@offers = Offer.accepted.not_in(_id: @ground.advert_offers_ids)
	end

	def create
		@offer = Offer.find(params[:offer_id])
		flash[:notice] = 'Оффер добавлен.' if @ground.add_rotator_offer_and_save(@offer)
		redirect_to ground_adverts_path(@ground)
	end

	def destroy
		@offer = Offer.find(params[:id])
		flash[:notice] = 'Оффер удалён.' if @ground.remove_rotator_offer_and_save(@offer)
		redirect_to ground_adverts_path(@ground)
 	end

	protected

	def find_nested_objects
		@ground = current_user.grounds.find(params[:ground_id])
	end

	def and_nested_crumbs
		add_crumb "Рекламные площадки", grounds_path
		add_crumb "Площадка «#{@ground.title}»", ground_path(@ground)
	end

end
