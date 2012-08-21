# coding: utf-8

class Admin::StatsController < Admin::BaseController

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

    cond = {:date => {'$gte' => t_start, '$lte' => t_stop}}
    cond[:offer_id] = @offer_id if @offer_id
    cond[:ground_id] = @ground_id if @ground_id
    cond[:sub_id] = @sub_id if @sub_id
    
    if current_user.class==Webmaster
      cond[:webmaster_id] = current_user.id
    else
      cond[:advertiser_id] = current_user.id
    end

    func = "function(obj,prev) { "
    func += "prev.target_count += obj.targets; "
    func += "prev.income_count += obj.income; "
    func += "prev.expenditure_count += obj.expenditure; "
    func += "prev.click_count += obj.clicks}"
    initial_params = {target_count: 0, income_count: 0, expenditure_count: 0, click_count: 0}
    h = {key: :date, cond: cond, initial: initial_params, reduce: func}
    
    @stats = StatCounter.collection.group(h)
  end
  
end
