# coding: utf-8

class Admin::AdvertsController < Admin::BaseController
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
		respond_with(@advert, :location => user_offer_advert_path(@user, @offer, @advert))
	end

	def update
    flash[:notice] = 'Объявление обновлено.' if @advert.update_attributes(params[@advert.class.to_s.underscore])
		respond_with(@advert, :location => user_offer_adverts_path(@user, @offer))
	end

	def destroy
		flash[:notice] = 'Объявление удалено.' if @advert.destroy
		respond_with(@advert, :location => user_offer_adverts_path(@user, @offer))
	end

  def edit
    @type = @advert.class
  end

	def new
		@type = params[:type].constantize if params[:type]
		@advert = @offer.adverts.build({}, @type)
		add_crumb "Новое объявление"
	end

	protected

	def find_nested_objects
		@user = User.find(params[:user_id])
		@offer = @user.offers.find(params[:offer_id])
	end

	def and_nested_crumbs
		add_crumb "Пользователи", users_path
		add_crumb "Пользователь «#{@user.email}»", user_path(@user)
		add_crumb "Рекламные кампании", user_offers_path(@user)
		add_crumb "Рекламная кампания «#{@offer.title}»", user_offer_path(@user, @offer)
		add_crumb "Объявления", user_offer_adverts_path(@user, @offer)
	end

	def find_object
		@advert = @offer.adverts.find(params[:id])
	end

	def and_crumbs
		add_crumb "Объявление"
	end
	
end
