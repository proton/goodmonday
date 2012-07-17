# coding: utf-8

class Admin::PaymentsController < Admin::BaseController
  respond_to :html

  before_filter :find_user

	def index
		@payments = @user.payments
    add_crumb "Пользователи", users_path
    add_crumb "Пользователь «#{@user.email}»", user_path(@user)
    add_crumb "Платежи", user_payments_path(@user)
  end

  def create
    @payment = @user.payments.new(params[:payment])
 		flash[:notice] = 'Платёж добавлен.' if @payment.save
 		respond_with(@payment, :location => user_payments_path(@user))
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

end
