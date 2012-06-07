# coding: utf-8

class Achievement
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Symbolize

  symbolize :state, :in => [:pending, :accepted, :denied], :default => :pending, :scopes => true
  symbolize :payment_state, :in => [:unpaid, :paid], :default => :unpaid, :scopes => true

	belongs_to :webmaster
	belongs_to :advertiser
	belongs_to :ground
	belongs_to :offer
	belongs_to :visitor
	field :target_id, type: BSON::ObjectId

	field :page, type: String
	field :ip, type: String
	index :ip

  field :sub_id, type: String

	field :price, type: Integer

	field :order_id, type: String #optional for manual confirmation

  field :hold_date, type: Date

	def is_accepted?
		self.state==:accepted
  end

  def prepay
    self.webmaster.inc(:hold_balance, self.price)
    self.advertiser.inc(:hold_balance, -self.price)
  end

  def pay
    amount = self.price
    if self.advertiser.can_pay? amount
      webmaster = self.webmaster
      webmaster.balance += amount
      webmaster.payments.new(amout: amount, description: 'Перечисление средств за цель')
      webmaster.save!
      #
      advertiser = self.advertiser
      advertiser.balance -= amount
      advertiser.payments.new(amout: -amount, description: 'Перечисление средств за цель')
      advertiser.save!
      #
      self.payment_state = :paid
      self.save!
    end
  end

  def accept(sum)
    offer = self.offer
    ground = self.ground
    target_id = self.target_id
    target = offer.targets.find(target_id)
    advertsiter_id = offer.advertsiter.id
    webmaster_id = ground.webmaster.id

    self.state = :accepted
    self.price = sum
    self.hold_date = Date.today + target.hold.days
    self.prepay

    #collecting statistic:
    today_stat = StatCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, advertiser_id: advertsiter_id, webmaster_id: webmaster_id, date: Date.today, sub_id: self.sub_id, target_id: target_id)
    total_stat = StatCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, advertiser_id: advertsiter_id, webmaster_id: webmaster_id, date: Date.new(0), sub_id: self.sub_id, target_id: target_id)
    today_stat.inc(:targets, 1)
    total_stat.inc(:targets, 1)
    today_stat.inc(:income, self.price)
    total_stat.inc(:income, self.price)
  end
end
