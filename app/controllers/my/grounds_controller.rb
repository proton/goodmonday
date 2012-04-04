# coding: utf-8

class My::GroundsController < My::BaseController
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs

	def index
		@grounds = current_user.grounds
	end

	def show
		add_crumb "Рекламная площадка «#{@ground.title}»"
	end

	def edit
		add_crumb "Рекламная площадка «#{@ground.title}»"
	end

	def new
		@ground = Ground.new
		add_crumb "Новая рекламная площадка"
	end

	def create
		@ground = Ground.new(params[:ground])
		@ground.webmaster = current_user
		flash[:notice] = 'Площадка добавлена.' if @ground.save
		respond_with(@ground, :location => my_grounds_path)
	end

	def update
		@ground = Ground.find(params[:id])
		flash[:notice] = 'Площадка обновлена.' if @ground.update_attributes(params[:ground])
		respond_with(@ground, :location => my_grounds_path)
	end

	def destroy
		flash[:notice] = 'Площадка удалена.' if @ground.destroy
		respond_with(@ground, :location => my_grounds_path)
	end

	protected

	def find_object
		@ground = Ground.find(params[:id])
	end

	def and_crumbs
		add_crumb "Рекламные площадки", my_grounds_path
	end

end
