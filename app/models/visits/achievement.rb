# coding: utf-8

class Achievement
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Symbolize
  include Mongoid::MoneyField

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

  money_field :webmaster_amount
  money_field :advertiser_amount

	field :order_id, type: String #optional for manual confirmation

  field :hold_date, type: Date

	def is_accepted?
		self.state==:accepted
  end

  def prepay
    webmaster = self.webmaster
    webmaster.hold_balance += self.webmaster_amount
    webmaster.save!
    #
    advertiser = self.advertiser
    advertiser.hold_balance -= self.advertiser_amount
    advertiser.save!
  end

  def pay
    webmaster_amount = self.webmaster_amount
    advertiser_amount = self.advertiser_amount
    if self.advertiser.can_pay? advertiser_amount
      webmaster = self.webmaster
      webmaster.balance += webmaster_amount
      webmaster.hold_balance -= webmaster_amount
      webmaster.total_payments += webmaster_amount
      p = webmaster.payments.new(description: 'Перечисление средств за цель')
      p.amount = webmaster_amount
      webmaster.save!
      #
      advertiser = self.advertiser
      advertiser.balance -= advertiser_amount
      advertiser.hold_balance += advertiser_amount
      advertiser.total_payments += advertiser_amount
      p = advertiser.payments.new(description: 'Перечисление средств за цель')
      p.amount = -advertiser_amount
      advertiser.save!
      #
      affiliator = webmaster.affiliator
      if affiliator
        affiliator_amount = webmaster_amount*0.05
        p = affiliator.payments.new(description: 'Перечисление средств по реферальной программе')
        p.amount = affiliator_amount
        advertiser.balance += affiliator_amount
        affiliator.referal_total_payments += affiliator_amount
        affiliator.save!
      end
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

    offer.payments += webmaster_amount
    offer.save

    #collecting statistic:
    webmaster_today_stat = StatTargetCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, user_id: webmaster_id, date: Date.today, sub_id: self.sub_id, target_id: target_id)
    advertiser_today_stat = StatTargetCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, user_id: advertiser_id, date: Date.today, sub_id: self.sub_id, target_id: target_id)
    webmaster_total_stat = StatTargetCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, user_id: webmaster_id, date: Date.new(0), sub_id: self.sub_id, target_id: target_id)
    advertiser_total_stat = StatTargetCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, user_id: advertiser_id, date: Date.new(0), sub_id: self.sub_id, target_id: target_id)
    webmaster_today_stat.inc(:targets, 1)
    advertiser_today_stat.inc(:targets, 1)
    webmaster_total_stat.inc(:targets, 1)
    advertiser_total_stat.inc(:targets, 1)
    webmaster_today_stat.inc(:income, self.webmaster_amount.cents)
    advertiser_today_stat.inc(:income, self.advertiser_amount.cents)
    webmaster_total_stat.inc(:income, self.webmaster_amount.cents)
    advertiser_total_stat.inc(:income, self.advertiser_amount.cents)
  end
end
