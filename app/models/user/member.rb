class Member < User
	has_many :offers
	has_many :achievements

  field :balance, type: Integer, default: 0
  field :hold_balance, type: Integer, default: 0
  field :overdraft, type: Integer, default: 0
  field :total_payments, type: Integer, default: 0
  embeds_many :payments #, cascade_callbacks: true

  #referal system
  field :referal_count, type: Integer, default: 0
  field :referal_hold_balance, type: Integer, default: 0
  field :referal_total_payments, type: Integer, default: 0

  def can_pay? sum
    (self.balance+self.overdraft) > sum
  end
end
