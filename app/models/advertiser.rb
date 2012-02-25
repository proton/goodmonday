class Advertiser < User
	has_many :offers
	has_many :achievements
end
