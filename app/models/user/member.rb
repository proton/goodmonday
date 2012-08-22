class Member < User
  include Mongoid::MoneyField

	has_many :offers
	has_many :achievements

  money_field :balance
  money_field :hold_balance
  money_field :overdraft
  money_field :total_payments
  embeds_many :payments #, cascade_callbacks: true

  #referal system
  field :referal_count, type: Integer, default: 0
  money_field :referal_total_payments

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
    stat = {:click => {}, :target => {}, :income => {}}
    for time in [:today, :yesterday, :week, :month, :total] do
      stat[:click][time] = counters[time].sum(:clicks)
      stat[:target][time] = counters[time].sum(:targets)
      stat[:income][time] = counters[time].sum(:income)
      for subj in [:click, :target, :income]
        stat[subj][time] = 0 unless stat[subj][time]
      end
    end
    stat
  end
end
