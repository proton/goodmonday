# coding: utf-8

class My::OffersController < My::BaseController

	def index
		@offers = current_user.offers
	end

	def create
		@offer = Offer.new(params[:offer])
		@offer.advertiser = current_user

		respond_to do |format|
			if @offer.save
				#format.html  { redirect_to(my_offer_path(@offer), :notice => 'Оффер успешно добавлен.') }
				format.html  { redirect_to(my_offers_path, :notice => 'Оффер успешно добавлен.') }
			else
				format.html  { render :action => "new" }
			end
		end
	end

	def update
		@offer = Offer.find(params[:id])

	  respond_to do |format|
	    if @offer.update_attributes(params[:offer])
				#format.html  { redirect_to(my_offer_path(@offer), :notice => 'Оффер успешно обновлен.') }
				format.html  { redirect_to(my_offers_path, :notice => 'Оффер успешно обновлен.') }
	    else
	      format.html  { render :action => "edit" }
	    end
	  end
	end
	
end
