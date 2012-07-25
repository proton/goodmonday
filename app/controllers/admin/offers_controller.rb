# coding: utf-8

class Admin::OffersController < Admin::BaseController
	before_filter :find_nested_objects
	before_filter :and_nested_crumbs
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@offers = @user.offers
		add_crumb "Рекламные кампании"
	end

	def create
		@offer = @user.offers.new(params[:offer])
		flash[:notice] = 'Оффер добавлен.' if @offer.save
		respond_with(@offer, :location => user_offer_path(@user, @offer))
	end

	def update
		flash[:notice] = 'Оффер обновлен.' if @offer.update_attributes(params[:offer])
		respond_with(@offer, :location => user_offer_path(@user, @offer))
	end

	def destroy
		flash[:notice] = 'Рекламная кампания удалена.' if @offer.destroy
		respond_with(@offer, :location => user_offers_path(@user))
	end

	def new
		@offer = Offer.new
		add_crumb "Рекламные кампании", offers_path
		add_crumb "Новая рекламная кампания"
	end

	def update_advertiser
		@new_user = User.find(params[:offer][:new_user_id])
		flash[:notice] = 'Рекламодатель изменён.' if @offer.change_advertiser!(@new_user)
		respond_with(@offer, :location => user_offer_path(@new_user, @offer))
	end

	protected

	def find_nested_objects
		@user = User.find(params[:user_id])
	end

	def and_nested_crumbs
		add_crumb "Пользователи", users_path
		add_crumb "Пользователь «#{@user.email}»", user_path(@user)
	end

	def find_object
		@offer = @user.offers.find(params[:id])
	end

	def and_crumbs
		add_crumb "Рекламные кампании", user_offers_path(@user)
		add_crumb "Рекламная кампания «#{@offer.title}»"
	end
end
