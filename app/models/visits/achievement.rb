# coding: utf-8

class Achievement
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Symbolize
  include Mongoid::MoneyField
  include Extensions::Aggregations

  symbolize :state, :in => [:pending, :accepted, :denied], :default => :pending, :scopes => true
  symbolize :payment_state, :in => [:unpaid, :paid], :default => :unpaid, :scopes => true

	belongs_to :webmaster
	belongs_to :advertiser
	belongs_to :ground
	belongs_to :offer
	belongs_to :visitor

  field :target_id, type: Moped::BSON::ObjectId
  field :webmaster_payment_id, type: Moped::BSON::ObjectId
  field :advertiser_payment_id, type: Moped::BSON::ObjectId
  field :affiliator_payment_id, type: Moped::BSON::ObjectId

  field :accepted_at, type: DateTime

	field :page, type: String
	field :ip, type: String
  index({ip: 1}, {background: true})

  field :sub_id, type: String

  money_field :webmaster_amount
  money_field :advertiser_amount

	field :order_id, type: String #optional for manual confirmation
  field :additional_info, type: String

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
    return false if self.state!=:accepted || self.payment_state!=:unpaid #TODO: advanced check for state
    webmaster_amount = self.webmaster_amount
    advertiser_amount = self.advertiser_amount
    if self.advertiser.can_pay? advertiser_amount
      webmaster = self.webmaster
      webmaster.hold_balance -= webmaster_amount
      webmaster.total_payments += webmaster_amount
      webmaster.save!
      p = webmaster.payments.new(description: 'Перечисление средств за цель')
      p.amount = webmaster_amount
      p.save!
      self.webmaster_payment_id = p.id
      #
      advertiser = self.advertiser
      advertiser.hold_balance += advertiser_amount
      advertiser.total_payments += advertiser_amount
      advertiser.save!
      p = advertiser.payments.new(description: 'Перечисление средств за цель')
      p.amount = -advertiser_amount
      p.save!
      self.advertiser_payment_id = p.id
      #
      affiliator = webmaster.affiliator
      if affiliator
        payment_id = affiliator.referral_pay(webmaster_amount*0.05, :percentage)
        self.affiliator_payment_id = payment_id
      end
      #
      self.payment_state = :paid
      self.save!
    end
  end

  def accept(webmaster_amount, advertiser_amount)
    offer = self.offer
    #
    self.state = :accepted
    self.accepted_at = Time.now
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

    collect_statistics
  end

  def cancel!
    if self.state==:accepted
      self.accepted_at = nil
      offer = self.offer
      webmaster = self.webmaster
      advertiser = self.advertiser
      webmaster_amount = self.webmaster_amount
      advertiser_amount = self.advertiser_amount
      #
      offer.payments -= webmaster_amount
      offer.save

      collect_statistics(true)

      case self.payment_state
      when :unpaid
        if webmaster
          webmaster.hold_balance -= self.webmaster_amount
          webmaster.save!
        end
        if advertiser
          advertiser.hold_balance += self.advertiser_amount
          advertiser.save!
        end
      when :paid
        if webmaster
          webmaster.balance -= webmaster_amount
          webmaster.total_payments -= webmaster_amount
          p = webmaster.payments.find(self.webmaster_payment_id)
          p.delete
          webmaster.save!
          #
          affiliator = webmaster.affiliator
          if affiliator && self.affiliator_payment_id
            p = advertiser.payments.find(self.affiliator_payment_id)
            affiliator_amount = p.amount
            p.delete
            advertiser.balance -= affiliator_amount
            affiliator.referral_total_payments -= affiliator_amount
            affiliator.save!
          end
        end
        if advertiser
          advertiser.balance += advertiser_amount
          advertiser.total_payments += advertiser_amount
          p = advertiser.payments.find(self.advertiser_payment_id)
          p.delete
          advertiser.save!
        end
      end
    end
    self.state = :denied
    self.save!
  end

  def target
    return offer.targets.find(self.target_id) if offer
    nil
  end

  def collect_statistics(decrease = false)
    h = {ground_id: self.ground_id, offer_id: self.offer_id, advertiser_id: self.advertiser_id, webmaster_id: self.webmaster_id, sub_id: self.sub_id, target_id: self.target_id}
    today_stat = StatCounter.find_or_create_by(h.merge(date: self.created_at))
    total_stat = StatCounter.find_or_create_by(h.merge(date: Date.new(0)))
    values = {}
    values[:targets] = 1
    values[:income] = self.webmaster_amount.cents
    values[:expenditure] = self.advertiser_amount.cents
    [today_stat, total_stat].each do |s|
      values.each do |k,v|
        unless decrease
          s.inc(k, v)
        else
          s.inc(k, -v)
        end
      end
    end
  end
end
