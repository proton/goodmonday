class Payment
  include Mongoid::Document
 	include Mongoid::Timestamps
  include Mongoid::MoneyField
  embedded_in :member

  money_field :amount
  field :description, type: String, default: ''

  default_scope desc(:created_at)
end
