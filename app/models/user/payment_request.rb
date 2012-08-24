class PaymentRequest
  include Mongoid::Document
  include Mongoid::Symbolize
 	include Mongoid::Timestamps::Created

  belongs_to :user
  belongs_to :payment

  symbolize :state, :in => [:unpaid, :paid, :canceled], :default => :unpaid

  field :wallet, type: String, default: ''

  def pay
    p = self.user.payments.new
    p.description = "Выплата средств по запросу на кошелёк #{self.wallet}"
    p.amount = -user.balance
    p.save and self.update_attributes(state: :paid)
  end

  def cancel
    self.update_attributes(state: :canceled)
  end
end
