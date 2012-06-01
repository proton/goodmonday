# coding: utf-8

class My::StatsController < My::BaseController

	def index
		add_crumb "Статистика"

    if current_user.class==Webmaster
      counters = StatCounter.where(:webmaster_id => current_user.id)
    else
      counters = StatCounter.where(:adversiter_id => current_user.id)
    end

    @period = (Date.today-2.weeks)..(Date.today)
    counters = counters.where(:date => @period)

    #counters = {}
    #counters[:today] = user_counters.where(:date => Date.today)
    #counters[:yesterday] = user_counters.where(:date => Date.yesterday)
    #counters[:week] = user_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.week)
    #counters[:month] = user_counters.where(:date.lte => Date.today, :date.gt => Date.today-1.month)
    #counters[:total] = user_counters.where(:date => Date.new(0))
    #stat = {:click => {}, :target => {}, :income => {}}
    #for time in [:today, :yesterday, :week, :month, :total] do
    #  for subj in [:click, :target, :income]
    #    v = counters[time].where(:subject => subj).sum(:value)
    #    stat[subj][time] = v ? v : 0
    #  end
    #end
    #stat
	end
	
end
