class Suspicion
  include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Symbolize

	symbolize :state, :in => [:pending, :accepted, :denied], :default => :pending, :scopes => true

	belongs_to :visitor

	field :ip, type: String
	field :reason_text, type: String

	def block(period = nil)
		black_ip = BlackIp.new(self.ip)
		if period
			black_ip.discard_at = DateTime.now+period
		end
		if black_ip.save
			self.update_state(:accepted)
			Achievement.pending.where(:ip => self.ip).update_all(state: :denied)
		end
	end

	def forgive
		self.update_state(:denied)
	end

end
