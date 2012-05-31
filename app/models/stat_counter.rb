class StatCounter
	include Mongoid::Document

  belongs_to :ground, index: true
  belongs_to :offer, index: true
  belongs_to :adversiter, index: true
  belongs_to :webmaster, index: true

  field :date, type: Date
  field :sub_id, type: String
  field :target_id, type: BSON::ObjectId
  field :subject, type: Symbol

  field :value, type: Integer

  index :date
  index :sub_id

  index({ webmaster_id: 1, date: 1 })
  index({ adversiter_id: 1, date: 1 })

  #index({ webmaster_id: 1, ground_id: 1 })
  #index({ webmaster_id: 1, offer_id: 1 })
  #index({ webmaster_id: 1, sub_id: 1 })
  #
  #index({ adversiter_id: 1, ground_id: 1 })
  #index({ adversiter_id: 1, offer_id: 1 })
  #
  #index({ webmaster_id: 1, ground_id: 1, offer_id: 1 })
  #index({ webmaster_id: 1, ground_id: 1, date: 1 })
  #index({ webmaster_id: 1, ground_id: 1, sub_id: 1 })
  #index({ webmaster_id: 1, offer_id: 1, date: 1 })
  #index({ webmaster_id: 1, offer_id: 1, sub_id: 1 })
  #index({ webmaster_id: 1, date: 1, sub_id: 1 })
  #
  #index({ adversiter_id: 1, ground_id: 1, offer_id: 1 })
  #index({ adversiter_id: 1, ground_id: 1, date: 1 })
  #index({ adversiter_id: 1, offer_id: 1, date: 1 })

  def self.common_stat_for(user)
    if user.class==Webmaster
      user_counters = StatCounter.where(:webmaster_id => user.id)
    else
      user_counters = StatCounter.where(:adversiter_id => user.id)
    end
    counters = {}
    counters[:today] = user_counters.where(:date => Date.today)
    counters[:yesterday] = user_counters.where(:date => Date.yesterday)
    counters[:week] = user_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.week)
    counters[:month] = user_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.month)
    counters[:total] = user_counters.where(:date => Date.new(0))
    stat = {:click => {}, :target => {}, :income => {}}
    for time in [:today, :yesterday, :week, :month, :total] do
      for subj in [:click, :target, :income]
        v = counters[time].where(:subject => subj).sum(:value)
        stat[subj][time] = v ? v : 0
      end
    end
    stat
  end
end
