	# coding: utf-8

class Admin::GroundsController < Admin::BaseController
	before_filter :find_nested_objects
	before_filter :and_nested_crumbs
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs

	def index
		@grounds = @user.grounds
	end

	def show
		add_crumb "Рекламная площадка «#{@ground.title}»"
	end

	def edit
		add_crumb "Рекламная площадка «#{@ground.title}»"
	end

	def new
		@ground = @user.grounds.new
		add_crumb "Новая рекламная площадка"
	end

	def create
		@ground = @user.grounds.new(params[:ground])
		flash[:notice] = 'Площадка добавлена.' if @ground.save
		respond_with(@ground, :location => user_ground_path(@user, @ground))
	end

	def update
		@ground = Ground.find(params[:id])
		flash[:notice] = 'Площадка обновлена.' if @ground.update_attributes(params[:ground])
		respond_with(@ground, :location => user_ground_path(@user, @ground))
	end

	def destroy
		flash[:notice] = 'Площадка удалена.' if @ground.destroy
		respond_with(@ground, :location => user_grounds_path(@user))
	end

	def update_webmaster
		@new_user = User.find(params[:ground][:new_user_id])
		flash[:notice] = 'Вебмастер изменён.' if @offer.change_webmaster!(@new_user)
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
		@ground = @user.grounds.find(params[:id])
	end

	def and_crumbs
		add_crumb "Рекламные площадки", user_grounds_path(@user)
	end

end
