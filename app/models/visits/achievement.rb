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
  field :webmaster_payment_id, type: BSON::ObjectId
  field :advertiser_payment_id, type: BSON::ObjectId
  field :affiliator_payment_id, type: BSON::ObjectId

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

  def build_prototype(offer, visitor, target_id)
    self.webmaster = visitor.ground.webmaster
    self.advertiser = offer.advertiser
    self.ground = visitor.ground
    self.sub_id = visitor.sub_id
    self.offer = offer
    self.visitor = visitor
    self.target_id = target_id
  end

  def pay
    return false if self.state!=:accepted || self.payment_state!=unpaid #TODO: advanced check for state
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
      self.webmaster_payment_id = p.id
      #
      advertiser = self.advertiser
      advertiser.balance -= advertiser_amount
      advertiser.hold_balance += advertiser_amount
      advertiser.total_payments += advertiser_amount
      p = advertiser.payments.new(description: 'Перечисление средств за цель')
      p.amount = -advertiser_amount
      advertiser.save!
      self.advertiser_payment_id = p.id
      #
      affiliator = webmaster.affiliator
      if affiliator
        affiliator_amount = webmaster_amount*0.05
        p = affiliator.payments.new(description: 'Перечисление средств по реферальной программе')
        p.amount = affiliator_amount
        advertiser.balance += affiliator_amount
        affiliator.referal_total_payments += affiliator_amount
        affiliator.save!
        self.affiliator_payment_id = p.id
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
    #
    self.state = :accepted
    self.webmaster_amount = webmaster_amount
    self.advertiser_amount = advertiser_amount
    self.hold_date = Date.today + target.hold.days
    #
    webmaster = self.webmaster
    webmaster.hold_balance += self.webmaster_amount
    webmaster.save!
    #
    advertiser = self.advertiser
    advertiser.hold_balance -= self.advertiser_amount
    advertiser.save!
    #
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

  def cancel!
    case self.state
    when :pending
      self.state = :denied
    when :accepted
      offer = self.offer
      ground = self.ground
      target_id = self.target_id
      target = offer.targets.find(target_id)
      advertiser_id = offer.advertiser.id
      webmaster_id = ground.webmaster.id
      webmaster = self.webmaster
      advertiser = self.advertiser
      webmaster_amount = self.webmaster_amount
      advertiser_amount = self.advertiser_amount
      #
      offer.payments -= webmaster_amount
      offer.save

      webmaster_today_stat = StatTargetCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, user_id: webmaster_id, date: Date.today, sub_id: self.sub_id, target_id: target_id)
      advertiser_today_stat = StatTargetCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, user_id: advertiser_id, date: Date.today, sub_id: self.sub_id, target_id: target_id)
      webmaster_total_stat = StatTargetCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, user_id: webmaster_id, date: Date.new(0), sub_id: self.sub_id, target_id: target_id)
      advertiser_total_stat = StatTargetCounter.find_or_create_by(ground_id: ground.id, offer_id: offer.id, user_id: advertiser_id, date: Date.new(0), sub_id: self.sub_id, target_id: target_id)
      webmaster_today_stat.inc(:targets, -1)
      advertiser_today_stat.inc(:targets, -1)
      webmaster_total_stat.inc(:targets, -1)
      advertiser_total_stat.inc(:targets, -1)
      webmaster_today_stat.inc(:income, -self.webmaster_amount.cents)
      advertiser_today_stat.inc(:income, -self.advertiser_amount.cents)
      webmaster_total_stat.inc(:income, -self.webmaster_amount.cents)
      advertiser_total_stat.inc(:income, -self.advertiser_amount.cents)

      case self.payment_state
      when :unpaid
        webmaster.hold_balance -= self.webmaster_amount
        webmaster.save!
        advertiser.hold_balance += self.advertiser_amount
        advertiser.save!
      when :paid
        webmaster.balance -= webmaster_amount
        webmaster.total_payments -= webmaster_amount
        p = webmaster.payments.find(self.webmaster_payment_id)
        p.delete
        webmaster.save!
        #
        advertiser.balance += advertiser_amount
        advertiser.total_payments += advertiser_amount
        p = advertiser.payments.find(self.advertiser_payment_id)
        p.delete
        advertiser.save!
        #
        affiliator = webmaster.affiliator
        if affiliator && self.affiliator_payment_id
          p = advertiser.payments.find(self.affiliator_payment_id)
          affiliator_amount = p.amount
          p.delete
          advertiser.balance -= affiliator_amount
          affiliator.referal_total_payments -= affiliator_amount
          affiliator.save!
        end
      end
    when :denied
      #do nothing
    end
    self.save!
  end
end
