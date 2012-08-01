class Payment
  include Mongoid::Document
 	include Mongoid::Timestamps::Created
  include Mongoid::MoneyField
  embedded_in :member

  before_create :increase_member_balance
  before_create :set_timestamp

  money_field :amount
  field :description, type: String, default: ''

  default_scope desc(:created_at)

  def increase_member_balance
    self.member.balance += self.amount
    self.member.save
  end

  def set_timestamp
    self.created_at = Time.now
  end
end
