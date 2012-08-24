# coding: utf-8

class My::PaymentRequestsController < My::BaseController
  respond_to :html

	def new
    @payment_request = current_user.payment_requests.new
    add_crumb "Запрос выплат", new_payment_request_path
  end

  def create
    @payment_request = current_user.payment_requests.new(params[:payment_request])
    flash[:notice] = 'Выплата запрошена' if @payment_request.save
    redirect_to root_path
  end

end
