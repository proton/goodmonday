# coding: utf-8

class Admin::GroundOffersController < Admin::BaseController
	before_filter :find_nested_objects
	before_filter :and_nested_crumbs
	before_filter :find_object, :only => [:accept, :deny]

	def index
		@ground_offers = @offer.ground_offers
		add_crumb "Рекламные площадки"
	end

	def accept
		@ground_offer = @offer.ground_offers.find(params[:ground_id])
		@ground_offer.state = :accepted
		@ground_offer.save
		flash[:notice] = 'Площадка одобрена.' if @ground_offer.save
		redirect_to :back
	end

	def deny
		@ground_offer = @offer.ground_offers.find(params[:ground_id])
		@ground_offer.state = :denied
		flash[:notice] = 'Площадка отклонена.' if @ground_offer.save
		redirect_to :back
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
		@ground_offer = @offer.ground_offers.find(params[:ground_id])
	end

end
