# coding: utf-8

class Member < User
  include Mongoid::MoneyField

	has_many :offers
	has_many :achievements

  money_field :balance
  money_field :hold_balance
  money_field :overdraft
  money_field :total_payments
  embeds_many :payments #, cascade_callbacks: true

  #referral system
  field :referral_count, type: Integer, default: 0
  money_field :referral_total_payments
  field :referral_reward_paid, type: Boolean, default: false

  field :blocked, type: Boolean, default: false

  def title
    self.email
  end

  def can_pay? sum
    (self.balance+self.overdraft) > sum
  end

  def common_stats
    user_counters = case self.class
      when Webmaster
        StatCounter.where(:webmaster_id => self.id)
      when Advertiser
        StatCounter.where(:advertiser_id => self.id)
      end
    #
    counters = {}
    counters[:today] = user_counters.where(:date => Date.today)
    counters[:yesterday] = user_counters.where(:date => Date.yesterday)
    counters[:week] = user_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.week)
    counters[:month] = user_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.month)
    counters[:total] = user_counters.where(:date => Date.new(0))
    #
    stat = {:click => {}, :target => {}, :income => {}, :expenditure => {}}
    for time in [:today, :yesterday, :week, :month, :total] do
      stat[:click][time] = counters[time].sum(:clicks)
      stat[:target][time] = counters[time].sum(:targets)
      stat[:income][time] = counters[time].sum(:income)
      stat[:expenditure][time] = counters[time].sum(:expenditure)
      for subj in [:click, :target, :income, :expenditure]
        stat[subj][time] = 0 unless stat[subj][time]
      end
    end
    stat
  end

  def referral_pay(amount, marker)
    payment_id = nil
    if amount>0
      self.referral_total_payments += amount
      self.save!
      p = self.payments.new(description: 'Перечисление средств по реферальной программе')
      p.amount = affiliator_amount
      payment_id = p.id if p.save!
    end

    offer = Offer.find_by_mark('goodmonday_referral')
    if offer
      if amount>0
        offer.payments += affiliator_amount
        offer.save
      end

      target = offer.find_marked_target('goodmonday_referral_'+marker.to_s)
      target_id = (target)? target.id : nil

      h = {ground_id: nil, offer_id: offer.id, advertiser_id: offer.advertiser_id, webmaster_id: self.id, sub_id: nil, target_id: target_id}
      today_stat = StatCounter.find_or_create_by(h.merge(date: Date.today))
      total_stat = StatCounter.find_or_create_by(h.merge(date: Date.new(0)))
      values = {}
      values[:targets] = (marker==:reward)? 1 : 0
      values[:income] = amount.cents
      values[:expenditure] = amount.cents
      [today_stat, total_stat].each do |s|
        values.each do |k,v|
          s.inc(k, v)
        end
      end
    end

    return payment_id
  end
end
