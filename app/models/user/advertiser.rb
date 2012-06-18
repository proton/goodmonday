class Advertiser < Member
	has_many :offers, dependent: :delete
	has_many :achievements
end
