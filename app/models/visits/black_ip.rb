class BlackIp
  include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Symbolize

  symbolize :type, :in => [:permanently, :temporarily], :default => :permanently, :scopes => true

	field :ip, type: String
	index :ip, unique: true
	field :discard_at, type: DateTime
  field :reason, type: String

	def self.include(ip)
		BlackIp.where(:ip => ip).size!=0
	end

	def self.exclude(ip)
		BlackIp.where(:ip => ip).size==0
	end
end
