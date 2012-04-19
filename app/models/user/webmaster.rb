class Webmaster < User
	include Mongoid::Symbolize

	has_many :grounds
	has_many :achievements

	field :balance, type: Integer, default: 0

	symbolize :rank, :in => [:bronze, :silver, :gold], :default => :bronze
end
