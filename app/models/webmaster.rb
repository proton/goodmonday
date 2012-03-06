class Webmaster < User
	has_many :grounds
	has_many :achievements

	field :balance, type: Integer, default: 0
end
