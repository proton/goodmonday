class Suspicion
  include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Symbolize

	symbolize :state, :in => [:pending, :accepted, :denied], :default => :pending, :scopes => true

	belongs_to :visitor

	field :ip, type: String
	field :reason_text, type: String

	def block(period = nil)
		black_ip = BlackIp.new
    black_ip.ip = self.ip
		if period
			black_ip.discard_at = DateTime.now+period
		end
		if black_ip.save
      self.update_attribute(:state, :accepted)
			Achievement.pending.where(:ip => self.ip).update(state: :denied)
		end
	end

	def forgive
    self.update_attribute(:state, :denied)
	end

end
