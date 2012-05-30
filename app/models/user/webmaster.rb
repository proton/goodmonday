class Webmaster < User
	include Mongoid::Symbolize

	has_many :grounds
	has_many :achievements

  field :balance, type: Integer, default: 0

  field :sub_ids, type: Array, default: []

	symbolize :rank, :in => [:bronze, :silver, :gold], :default => :bronze
end
