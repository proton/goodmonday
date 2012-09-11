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
        @offer_id = Moped::BSON::ObjectId(params[:filter][:offer])
      end
      if params[:filter][:ground] && !params[:filter][:ground].empty?
        @ground_id = Moped::BSON::ObjectId(params[:filter][:ground])
      end
      if params[:filter][:sub_id] && !params[:filter][:sub_id].empty?
        @sub_id = Moped::BSON::ObjectId(params[:filter][:sub_id])
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
    elsif current_user.class==Advertiser
      cond[:advertiser_id] = current_user.id
    end

    func = "function(obj,prev) { "
    func += "prev.targets_count += obj.targets; "
    func += "prev.income_count += obj.income; "
    func += "prev.expenditure_count += obj.expenditure; "
    func += "prev.clicks_count += obj.clicks}"
    initial_params = {targets_count: 0, income_count: 0, expenditure_count: 0, clicks_count: 0}
    h = {key: :date, cond: cond, initial: initial_params, reduce: func}
    
    @stats = StatCounter.collection.group(h)

    if current_user.class==Webmaster
      @user_offers = current_user.accepted_offers
    elsif current_user.class==Advertiser
      @user_offers = current_user.offers
    end
  end
  
end
