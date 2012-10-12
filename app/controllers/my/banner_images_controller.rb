# coding: utf-8

class My::BannerImagesController < My::BaseController
	before_filter :find_advert

  def index
    respond_to do |format|
      format.json { render :json => @advert.banner_images.collect { |p| p.to_jq_upload }.to_json }
    end
  end

  def show
    @banner_image = @advert.banner_images.find(params[:id])
    respond_to do |format|
      format.json { render json: @banner_image }
    end
  end

  def new
    @banner_image = @advert.banner_images.new
    respond_to do |format|
      format.json { render json: @banner_image }
    end
  end

	def create
		@banner_image = @advert.banner_images.build(params[:banner_image])
		#if @banner_image.valid?
		#	flash[:notice] = 'valid'
		#else
		#	flash[:error] = 'invalid'
		#end
    respond_to do |format|
      if @banner_image.save
        format.html { redirect_to offer_advert_path(@offer, @advert), notice: 'Изображение добавлено.' }
        format.json { render :json => [ @banner_image.to_jq_upload ].to_json }
      else
        error = @banner_image.errors.messages[:size] ? 'Неверный размер изображения' : @banner_image.errors.full_messages
        format.html { redirect_to offer_advert_path(@offer, @advert), error: error }
        format.json { render :json => [ @banner_image.to_jq_upload.merge({ :error => error }) ].to_json }
      end
    end
	end

	def destroy
    @banner_image = @advert.banner_images.find(params[:id])
    @banner_image.destroy
    respond_to do |format|
      format.html { redirect_to offer_advert_path(@offer, @advert), notice: 'Изображение удалено.' }
      format.json { render :json => true }
    end
 end

  private

	def find_advert
		@offer = current_user.offers.find(params[:offer_id])
		@advert = @offer.adverts.find(params[:advert_id])
	end
	
end
