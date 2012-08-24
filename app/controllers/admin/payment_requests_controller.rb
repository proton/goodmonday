# coding: utf-8

class Admin::PaymentsRequestsController < Admin::BaseController
  respond_to :html

	def index
    add_crumb "Запросы выплат", payment_requests_path
    @payment_requests= {}
    [:unpaid, :paid, :canceled].each do |state|
      @payment_requests[state] = PaymentsRequest.where(state: state)
    end
  end

  def pay
    @achievement = @user.achievements.find(params[:achievement_id])
    flash[:notice] = 'Выплата произведена.' if @payment_request.pay
    redirect_to payment_requests_path
  end

  def cancel
    @payment_request = PaymentsRequest.find(params[:payment_request_id])
    flash[:notice] = 'Запрос выплат отклонён.' if @payment_request.cancel
    redirect_to payment_requests_path
  end

end
