class Payment
  include Mongoid::Document
 	include Mongoid::Timestamps
  embedded_in :member

  field :amount, type: Integer, default: 0
  field :description, type: String, default: ''
end
