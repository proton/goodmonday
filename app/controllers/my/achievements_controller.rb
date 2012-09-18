# coding: utf-8

class My::AchievementsController < My::BaseController
	before_filter :and_crumbs

	def index
    @achievements = {}
    [:pending, :accepted, :denied].each do |state|
      @achievements[state] = current_user.achievements.where(state: state)
    end
	end

	def show
		@achievement = current_user.achievements.find(params[:id])
		add_crumb "Достижение"
	end

  def report
    add_crumb "Отчёт"

    @created_at_start = set_filter_param(Date.today-1.month, :created_at_start, :date)
    @created_at_stop = set_filter_param(Date.today, :created_at_stop, :date)
    #@accepted_at_start = set_filter_param(Date.today-1.month, :accepted_at_start, :date)
    #@accepted_at_stop = set_filter_param(Date.today, :accepted_at_stop, :date)
    @ground_id = set_filter_param(nil, :ground, :id)
    @offer_id = set_filter_param(nil, :offer, :id)
    @state = set_filter_param(nil, :state, :symbol)
    @group_by = set_filter_param(:offer_id, :group_by, :symbol)

    ct_start = date2time(@created_at_start)
    ct_stop =  date2time(@created_at_stop)+1.day-1.second
    #at_start = date2time(@accepted_at_start)
    #at_stop =  date2time(@accepted_at_stop)+1.day-1.second

    cond = {}
    cond[:created_at] = {'$gte' => ct_start, '$lte' => ct_stop}
    #cond[:accepted_at] = {'$gte' => at_start, '$lte' => at_stop}

    if current_user.class==Webmaster
      cond[:webmaster_id] = current_user.id
    elsif current_user.class==Advertiser
      cond[:advertiser_id] = current_user.id
    end
    cond[:offer_id] = @offer_id if @offer_id
    cond[:ground_id] = @ground_id if @ground_id
    cond[:state] = @state if @state

    group_by = @group_by
    if @group_by==:amount
      if current_user.class==Webmaster
        group_by = :webmoster_amount_сents
      elsif current_user.class==Advertiser
        group_by = :advertiser_amount_сents
      end
    end
    @achievements_data = Achievement.group_by(group_by, :sum => %w[webmoster_amount_сents advertiser_amount_сents], :cond => cond, :sort_desc => [:_id])
  end

  protected

	def and_crumbs
		add_crumb "Достижения целей", achievements_path
  end

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

  def date2time(date)
    Time.utc(date.year,date.month,date.day)
  end

end
