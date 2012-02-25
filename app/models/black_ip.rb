class BlackIp
  include Mongoid::Document
	include Mongoid::Timestamps

	field :ip, type: String
	index :ip, unique: true

	def self.include(ip)
		BlackIp.where(:ip => ip).size!=0
	end

	def self.exclude(ip)
		BlackIp.where(:ip => ip).size==0
	end

	def initialize(ip)
		self.ip = ip
	end
end
