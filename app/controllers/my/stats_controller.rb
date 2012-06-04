# coding: utf-8

class My::StatsController < My::BaseController

	def index
		add_crumb "Статистика"

    @date_start = Date.today-2.weeks
    @date_stop = Date.today
    if params[:filter][:date_start]
      @date_start = Date.parse(params[:filter][:date_start])
    end
    if params[:filter][:date_stop]
      @date_stop = Date.parse(params[:filter][:date_stop])
    end
    t_start =  Time.utc(@date_start.year,@date_start.month,@date_start.day)
    t_stop =  Time.utc(@date_stop.year,@date_stop.month,@date_stop.day)

    cond = {:date => {'$gte' => t_start, '$lte' => t_stop}}

    if current_user.class==Webmaster
      cond[:webmaster_id] = current_user.id
      #cond = {:date => {'$gte' => t_start, '$lte' => t_stop}, :webmaster_id => current_user.id}
    else
      cond[:advertiser_id] = current_user.id
      #cond = {:date => {'$gte' => t_start, '$lte' => t_stop}, :advertiser_id => current_user.id}
    end

    func = "function(obj,prev) { prev.click_count += obj.clicks; prev.target_count += obj.targets; prev.income_count += obj.income}"
    h = {key: :date, cond: cond, initial: {click_count: 0, target_count: 0, income_count: 0}, reduce: func}
    @stats = StatCounter.collection.group(h)
	end
	
end
