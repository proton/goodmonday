# coding: utf-8

class My::StatsController < My::BaseController

  def index
    add_crumb "Статистика"

    @date_total = set_filter_param(false, :date_total, :boolean)
    @date_start = set_filter_param(Date.today-2.weeks, :date_start, :date)
    @date_stop = set_filter_param(Date.today, :date_stop, :date)
    @webmaster_id = set_filter_param(nil, :webmaster, :id)
    @advertiser_id = set_filter_param(nil, :advertiser, :id)
    @ground_id = set_filter_param(nil, :ground, :id)
    @offer_id = set_filter_param(nil, :offer, :id)
    @sub_id = set_filter_param(nil, :sub_id, :text)
    @group_by = set_filter_param(:date, :group_by, :symbol)

    t_start =  Time.utc(@date_start.year,@date_start.month,@date_start.day)
    t_stop =  Time.utc(@date_stop.year,@date_stop.month,@date_stop.day)

    cond = {}
    if @date_total
      cond[:date] = Time.utc(0)
    else
      cond[:date] = {'$gte' => t_start, '$lte' => t_stop}
    end

    if current_user.class==Webmaster
      cond[:webmaster_id] = current_user.id
    elsif current_user.class==Advertiser
      cond[:advertiser_id] = current_user.id
    end
    cond[:offer_id] = @offer_id if @offer_id
    cond[:ground_id] = @ground_id if @ground_id
    cond[:sub_id] = @sub_id if @sub_id

    @stats = StatCounter.group_by(@group_by, :sum => %w[targets income expenditure clicks], :cond => cond, :sort_desc => [:_id])
  end

  private

  def set_filter_param(v, name, type = :raw)
    if params[:filter] && params[:filter][name] && !params[:filter][name].empty?
      v = params[:filter][name]
      case type
        when :date
          v = Date.parse(v)
        when :symbol
          v = v.to_sym
        when :id
          v = Moped::BSON::ObjectId(v)
        when :text
          v = v.to_s
        when :boolean
          v = [true, 'true', 1, '1', 'T', 't'].include?(v.class == String ? v.downcase : v)
        when :raw
          #do nothing
      end
    end
    v
  end
  
end
