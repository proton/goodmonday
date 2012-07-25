# coding: utf-8

class OffersController < ApplicationController

	def index
    @offers = Offer.accepted.where('targets.moderated_state' => :accepted).order_by([:epc_cents, :desc])
    add_crumb "Рекламные кампании"
  end

	def show
    @offer = Offer.find(params[:id])
    add_crumb "Рекламные кампании", offers_path
		add_crumb "Рекламная кампания «#{@offer.title}»"
	end
end
