class Advertiser < Member
	has_many :offers, dependent: :delete
	has_many :achievements

  before_create :build_advertiser_profile
  embeds_one :advertiser_profile
end
