# coding: utf-8

class My::OffersController < My::BaseController
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@offers = current_user.offers
		add_crumb "Рекламные кампании"
	end

	def create
		@offer = Offer.new(params[:offer])
		@offer.advertiser = current_user
		flash[:notice] = 'Оффер успешно добавлен.' if @offer.save
		respond_with(@offer, :location => my_offers_path)
	end

	def update
		flash[:notice] = 'Оффер успешно обновлен.' if @offer.update_attributes(params[:offer])
		respond_with(@offer, :location => my_offers_path)
	end

	def new
		@offer = Offer.new
		add_crumb "Рекламные кампании", my_offers_path
		add_crumb "Новая рекламная кампания"
	end

	protected

	def find_object
		@offer = Offer.find(params[:id])
	end

	def and_crumbs
		add_crumb "Рекламные кампании", my_offers_path
		add_crumb "Рекламная кампания «#{@offer.title}»"
	end
end
