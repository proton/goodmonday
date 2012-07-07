class Member < User
	has_many :offers
	has_many :achievements

  field :balance, type: Integer, default: 0
  field :hold_balance, type: Integer, default: 0
  field :overdraft, type: Integer, default: 0
  field :total_payments, type: Integer, default: 0
  embeds_many :payments #, cascade_callbacks: true

  #referal system
  field :referal_count, type: Integer, default: 0
  field :referal_hold_balance, type: Integer, default: 0
  field :referal_total_payments, type: Integer, default: 0

  def can_pay? sum
    (self.balance+self.overdraft) > sum
  end

  def common_stats
    if self.is_a? Webmaster
      user_click_counters = StatClickCounter.where(:webmaster_id => self.id)
    elsif self.is_a? Advertiser
      user_click_counters = StatClickCounter.where(:advertiser_id => self.id)
    end
    user_target_counters = StatTargetCounter.where(:user_id => self.id)
    #
    click_counters = {}
    click_counters[:today] = user_click_counters.where(:date => Date.today)
    click_counters[:yesterday] = user_click_counters.where(:date => Date.yesterday)
    click_counters[:week] = user_click_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.week)
    click_counters[:month] = user_click_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.month)
    click_counters[:total] = user_click_counters.where(:date => Date.new(0))
    #
    target_counters = {}
    target_counters[:today] = user_target_counters.where(:date => Date.today)
    target_counters[:yesterday] = user_target_counters.where(:date => Date.yesterday)
    target_counters[:week] = user_target_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.week)
    target_counters[:month] = user_target_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.month)
    target_counters[:total] = user_target_counters.where(:date => Date.new(0))
    #
    stat = {:click => {}, :target => {}, :income => {}}
    for time in [:today, :yesterday, :week, :month, :total] do
      stat[:click][time] = click_counters[time].sum(:clicks)
      stat[:target][time] = target_counters[time].sum(:targets)
      stat[:income][time] = target_counters[time].sum(:income)
      for subj in [:click, :target, :income]
        stat[subj][time] = 0 unless stat[subj][time]
      end
    end
    stat
  end
end
