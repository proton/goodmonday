# coding: utf-8

class My::AdvertsController < My::BaseController
	inherit_resources
	belongs_to :offer
	before_filter :find_offer

	def find_offer
		@offer = current_user.offers.find(params[:offer_id])
	end

	def index
		@adverts = @offer.adverts
	end

	def new
		@type = params[:type].constantize if params[:type]
		@advert = @offer.adverts.build({}, @type)
	end

	def create
		@type = params[:type]
		@advert = @offer.adverts.build(params[@type.underscore], @type.constantize)

		respond_to do |format|
			if @advert.save
				format.html  { redirect_to(my_offer_advert_path(@offer, @advert), :notice => 'Объявление успешно добавлено.') }
			else
				format.html  { render :action => "new", :type=> @type }
			end
		end
	end
	
end
