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

  field :webmaster_amount, type: Integer
  field :advertiser_amount, type: Integer

	field :order_id, type: String #optional for manual confirmation

  field :hold_date, type: Date

	def is_accepted?
		self.state==:accepted
  end

  def prepay
    self.webmaster.inc(:hold_balance, self.webmaster_amount)
    self.advertiser.inc(:hold_balance, -self.advertiser_amount)
  end

  def pay
    webmaster_amount = self.webmaster_amount
    advertiser_amount = self.advertiser_amount
    if self.advertiser.can_pay? advertiser_amount
      webmaster = self.webmaster
      webmaster.balance += webmaster_amount
      webmaster.hold_balance -= webmaster_amount
      webmaster.total_payments += webmaster_amount
      webmaster.payments.new(amout: webmaster_amount, description: 'Перечисление средств за цель')
      webmaster.save!
      #
      advertiser = self.advertiser
      advertiser.balance -= advertiser_amount
      advertiser.hold_balance += advertiser_amount
      advertiser.total_payments += advertiser_amount
      advertiser.payments.new(amout: -advertiser_amount, description: 'Перечисление средств за цель')
      advertiser.save!
      #
      affiliator = webmaster.affiliator
      affiliator.inc(:referal_total_payments, webmaster_amount*0.05) if affiliator
      #
      self.payment_state = :paid
      self.save!
    end
  end

  def accept(webmaster_amount, advertiser_amount)
    offer = self.offer
    ground = self.ground
    target_id = self.target_id
    target = offer.targets.find(target_id)
    advertiser_id = offer.advertiser.id
    webmaster_id = ground.webmaster.id

    self.state = :accepted
    self.webmaster_amount = webmaster_amount
    self.advertiser_amount = advertiser_amount
    self.hold_date = Date.today + target.hold.days
    self.prepay

    #collecting statistic:
    #TODO: говно!!! у рекламодателя и вебмастера разные доходы и статистика должна быть разная
    today_stat = StatCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, advertiser_id: advertiser_id, webmaster_id: webmaster_id, date: Date.today, sub_id: self.sub_id, target_id: target_id)
    total_stat = StatCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, advertiser_id: advertiser_id, webmaster_id: webmaster_id, date: Date.new(0), sub_id: self.sub_id, target_id: target_id)
    today_stat.inc(:targets, 1)
    total_stat.inc(:targets, 1)
    today_stat.inc(:income, self.price)
    total_stat.inc(:income, self.price)
  end
end
