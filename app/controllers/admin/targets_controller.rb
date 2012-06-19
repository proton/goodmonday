# coding: utf-8

class Admin::TargetsController < Admin::BaseController
	before_filter :find_nested_objects
	before_filter :and_nested_crumbs
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@targets = @offer.targets
		add_crumb "Цели"
	end

	def create
    attrs = params[:target]
    [:fixed_price, :fixed_prices_bronze, :fixed_prices_silver, :fixed_prices_gold].each do |price|
      attrs[price]=attrs[price].to_i*100 if attrs[price]
    end
		@target = @offer.targets.new(attrs)
		flash[:notice] = 'Цель добавлена.' if @target.save
		respond_with(@target, :location => user_offer_targets_path(@user, @offer))
	end

	def update
    attrs = params[:target]
    [:fixed_price, :fixed_prices_bronze, :fixed_prices_silver, :fixed_prices_gold].each do |price|
      attrs[price]=attrs[price].to_i*100
    end
		flash[:notice] = 'Цель обновлена.' if @target.update_attributes(attrs)
		respond_with(@target, :location => user_offer_targets_path(@user, @offer))
	end

	def destroy
		flash[:notice] = 'Цель удалена.' if @target.destroy
		respond_with(@target, :location => user_offer_targets_path(@user, @offer))
	end

	def new
		@target = @offer.targets.new
		add_crumb "Цели", user_offer_targets_path(@user, @offer)
		add_crumb "Новая цель"
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
	end

	def find_object
		@target = @offer.targets.find(params[:id])
	end

	def and_crumbs
		add_crumb "Цели", user_offer_targets_path(@user, @offer)
		add_crumb "Цель «#{@target.title}»"
	end
	
end
