class Payment
  include Mongoid::Document
 	include Mongoid::Timestamps
  include Mongoid::MoneyField
  embedded_in :member

  before_create :increase_member_balance

  money_field :amount
  field :description, type: String, default: ''

  default_scope desc(:created_at)

  def increase_member_balance
    self.member.balance += self.amount
    self.member.save
  end
end
