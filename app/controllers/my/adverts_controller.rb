# coding: utf-8

class My::AdvertsController < My::BaseController
	before_filter :find_nested_objects
	before_filter :and_nested_crumbs
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@adverts = @offer.adverts
	end

	def create
		@type = params[:type]
		@advert = @offer.adverts.build(params[@type.underscore], @type.constantize)
		flash[:notice] = 'Объявление добавлено.' if @advert.save
		respond_with(@advert, :location => offer_advert_path(@offer, @advert))
	end

	def update
		flash[:notice] = 'Объявление обновлено.' if @advert.update_attributes(params[:advert])
		respond_with(@advert, :location => offer_adverts_path(@offer))
	end

	def destroy
		flash[:notice] = 'Объявление удалено.' if @advert.destroy
		respond_with(@advert, :location => offer_adverts_path(@offer))
	end

	def new
		@type = params[:type].constantize if params[:type]
		@advert = @offer.adverts.build({}, @type)
		add_crumb "Новое объявление"
	end

	protected

	def find_nested_objects
		@offer = current_user.offers.find(params[:offer_id])
	end

	def and_nested_crumbs
		add_crumb "Рекламные кампании", offers_path
		add_crumb "Рекламная кампания «#{@offer.title}»", offer_path(@offer)
		add_crumb "Объявления", offer_adverts_path(@offer)
	end

	def find_object
		@advert = @offer.adverts.find(params[:id])
	end

	def and_crumbs
		add_crumb "Объявление"
	end
	
end
