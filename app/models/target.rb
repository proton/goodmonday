class Target
  include Mongoid::Document
	embedded_in :offer

	has_many :achievements

	field :title, type: String
	field :fixed_price, type: Integer, default: 0
	field :prc_price, type: Integer, default: 0
	field :confirm_mode, type: Symbol, default: :auto
	field :confirm_url, type: String
	#TODO: должно быть 2 цены (вебмастера и рекламодателя)

	MODERATED_ATTRS = [:title, :fixed_price, :prc_price]
	include IsModerated
end
