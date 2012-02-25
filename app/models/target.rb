class Target
  include Mongoid::Document
	embedded_in :offer

	has_many :achievements

	field :title, type: String
	field :price, type: Integer
	#TODO: должно быть 2 цены (вебмастера и рекламодателя), а также 2 метода оплаты (процент от продаж и конкретная сумма)
end
