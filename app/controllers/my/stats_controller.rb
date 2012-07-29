# coding: utf-8

class My::StatsController < My::BaseController

	def index
		add_crumb "Статистика"

    @date_start = Date.today-2.weeks
    @date_stop = Date.today
    @offer_id = nil
    @ground_id = nil
    @sub_id = nil

    if params[:filter]
      if params[:filter][:date_start]
        @date_start = Date.parse(params[:filter][:date_start])
      end
      if params[:filter][:date_stop]
        @date_stop = Date.parse(params[:filter][:date_stop])
      end
      if params[:filter][:offer] && !params[:filter][:offer].empty?
        @offer_id = BSON::ObjectId(params[:filter][:offer])
      end
      if params[:filter][:ground] && !params[:filter][:ground].empty?
        @ground_id = BSON::ObjectId(params[:filter][:ground])
      end
      if params[:filter][:sub_id] && !params[:filter][:sub_id].empty?
        @sub_id = BSON::ObjectId(params[:filter][:sub_id])
      end
    end
    t_start =  Time.utc(@date_start.year,@date_start.month,@date_start.day)
    t_stop =  Time.utc(@date_stop.year,@date_stop.month,@date_stop.day)

    base_cond = {:date => {'$gte' => t_start, '$lte' => t_stop}}
    base_cond[:offer_id] = @offer_id if @offer_id
    base_cond[:ground_id] = @ground_id if @ground_id
    base_cond[:sub_id] = @sub_id if @sub_id
    click_cond = base_cond.clone
    target_cond = base_cond.clone

    if current_user.class==Webmaster
      click_cond[:webmaster_id] = current_user.id
    else
      click_cond[:advertiser_id] = current_user.id
    end
    target_cond[:user_id] = current_user.id

    click_func = "function(obj,prev) { prev.click_count += obj.clicks}"
    click_h = {key: :date, cond: click_cond, initial: {click_count: 0}, reduce: click_func}
    click_stats = StatClickCounter.collection.group(click_h)
    target_func = "function(obj,prev) { prev.target_count += obj.targets; prev.income_count += obj.income}"
    target_h = {key: :date, cond: target_cond, initial: {target_count: 0, income_count: 0}, reduce: target_func}
    target_stats = StatTargetCounter.collection.group(target_h)

    @click_stat_hash = {}
    click_stats.each do |stat|
      @click_stat_hash[stat['date']] = stat
    end
    @target_stat_hash = {}
    target_stats.each do |stat|
      @target_stat_hash[stat['date']] = stat
    end

    @dates = @click_stat_hash.keys | @target_stat_hash.keys
	end
	
end
