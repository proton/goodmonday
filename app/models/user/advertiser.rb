class Advertiser < User
	has_many :offers
	has_many :achievements

	field :balance, type: Integer, default: 0
end
