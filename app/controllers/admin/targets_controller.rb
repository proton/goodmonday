# coding: utf-8

class My::TargetsController < My::BaseController
	before_filter :find_nested_objects
	before_filter :and_nested_crumbs
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@targets = @offer.targets
		add_crumb "Цели"
	end

	def create
		@target = @offer.targets.new(params[:target])
		flash[:notice] = 'Цель добавлена.' if @target.save
		respond_with(@target, :location => offer_targets_path(@offer))
	end

	def update
		flash[:notice] = 'Цель обновлена.' if @target.update_attributes(params[:target])
		respond_with(@target, :location => offer_targets_path(@offer))
	end

	def new
		@target = @offer.targets.new
		add_crumb "Цели", offer_targets_path(@offer)
		add_crumb "Новая цель"
	end

	protected

	def find_nested_objects
		@offer = current_user.offers.find(params[:offer_id])
	end

	def and_nested_crumbs
		add_crumb "Рекламные кампании", offers_path
		add_crumb "Рекламная кампания «#{@offer.title}»", offer_path(@offer)
	end

	def find_object
		@target = @offer.targets.find(params[:id])
	end

	def and_crumbs
		add_crumb "Цели", offer_targets_path(@offer)
		add_crumb "Цель «#{@target.title}»"
	end
	
end
