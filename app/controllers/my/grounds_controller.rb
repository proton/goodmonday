# coding: utf-8

class My::GroundsController < My::BaseController

	def index
		@grounds = current_user.grounds
	end

	def create
		@ground = Ground.new(params[:ground])
		@ground.webmaster = current_user
		flash[:notice] = 'Площадка успешно добавлена.' if @ground.save
		respond_with(@ground, :location => my_grounds_path)
	end

	def update
		@ground = Ground.find(params[:id])
		flash[:notice] = 'Площадка успешно обновлена.' if @ground.update_attributes(params[:ground])
		respond_with(@ground, :location => my_grounds_path)
	end

	def new
		@ground = Ground.new
	end

end
