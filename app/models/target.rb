class Target
  include Mongoid::Document
	embedded_in :offer

	has_many :achievements

	field :title, type: String
	field :fixed_price, type: Integer, default: 0
	field :prc_price, type: Integer, default: 0
	#TODO: должно быть 2 цены (вебмастера и рекламодателя)
end
