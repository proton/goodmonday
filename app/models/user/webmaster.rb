class Webmaster < Member
	include Mongoid::Symbolize

  before_create :build_webmaster_profile

	has_many :grounds, dependent: :delete
	has_many :achievements

  embeds_one :webmaster_profile

  field :sub_ids, type: Array, default: []

	symbolize :rank, :in => [:bronze, :silver, :gold], :default => :bronze
end
