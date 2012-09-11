class HomeController < ApplicationController
	#before_filter :find_affiliation

  def index
    @news = News.desc(:created_at).limit(3)
    # @offers = Offer.accepted.where(is_adult: false).order_by([:epc, :desc]).limit(3)
    #@offers = Offer.accepted.order_by([:epc_cents, :desc]).limit(3)
    @offers = Offer.active_n_accepted.where('targets.moderated_state' => :accepted).order_by([:epc_cents, :desc]).limit(3)
  end

  protected

  #def find_affiliation
		#if params[:referral] && !params[:referral].empty?
		#	referral_id = params[:referral]
		#	referral = User.where(:_id => referral_id).first
		#	cookies[:referral] = referral_id if referral
		#end
  #end

end
