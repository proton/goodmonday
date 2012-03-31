# coding: utf-8

class My::OffersController < My::BaseController

	def index
		@offers = current_user.offers
	end

	def create
		@offer = Offer.new(params[:offer])
		@offer.advertiser = current_user
		flash[:notice] = 'Оффер успешно добавлен.' if @offer.save
		respond_with(@offer, :location => my_offers_path)
	end

	def update
		@offer = Offer.find(params[:id])
		flash[:notice] = 'Оффер успешно обновлен.' if @offer.update_attributes(params[:offer])
		respond_with(@offer, :location => my_offers_path)
	end
end
