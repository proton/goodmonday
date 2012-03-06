# coding: utf-8

class My::GroundsController < My::BaseController

	def index
		@grounds = current_user.grounds
	end

	def create
		@ground = Ground.new(params[:ground])
		@ground.webmaster = current_user

		respond_to do |format|
			if @ground.save
				format.html  { redirect_to(my_ground_path(@ground), :notice => 'Площадка успешно добавлена.') }
			else
				format.html  { render :action => "new" }
			end
		end
	end

	def update
		@ground = Ground.find(params[:id])

	  respond_to do |format|
	    if @ground.update_attributes(params[:ground])
	      format.html  { redirect_to(my_ground_path(@ground), :notice => 'Площадка успешно обновлена.') }
	    else
	      format.html  { render :action => "edit" }
	    end
	  end
	end

	def new
		@ground = Ground.new
	end

end
