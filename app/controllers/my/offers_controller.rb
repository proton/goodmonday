# coding: utf-8

class My::OffersController < My::BaseController
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :authorize, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@offers = current_user.offers
		add_crumb "Рекламные кампании"
	end

	def create
		@offer = current_user.offers.new(params[:offer])
		flash[:notice] = 'Оффер добавлен.' if @offer.save
		respond_with(@offer, :location => offer_path(@offer))
	end

	def update
		flash[:notice] = 'Оффер обновлен.' if @offer.update_attributes(params[:offer])
		respond_with(@offer, :location => offer_path(@offer))
	end

	def destroy
		flash[:notice] = 'Рекламная кампания удалена.' if @offer.destroy
		respond_with(@offer, :location => offers_path)
	end

	def new
		@offer = current_user.offers.new
		add_crumb "Рекламные кампании", offers_path
		add_crumb "Новая рекламная кампания"
	end

	protected

	def find_object
		@offer = current_user.offers.find(params[:id])
	end

	def authorize
		forbid unless @offer.advertiser==current_user
	end

	def and_crumbs
		add_crumb "Рекламные кампании", offers_path
		add_crumb "Рекламная кампания «#{@offer.title}»"
	end
end
