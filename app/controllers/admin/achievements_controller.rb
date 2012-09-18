# coding: utf-8

class Admin::AchievementsController < Admin::BaseController
	before_filter :find_nested_objects
	before_filter :and_crumbs

	def index
    @achievements = {}
    [:pending, :accepted, :denied].each do |state|
      @achievements[state] = @user.achievements.where(state: state)
    end
	end

	def show
		@achievement = @user.achievements.find(params[:id])
		add_crumb "Достижение"
	end

	def cancel
		@achievement = @user.achievements.find(params[:achievement_id])
		flash[:notice] = 'Достижение отменено.' if @achievement.cancel!
    redirect_to user_achievement_path(@user, @achievement)
	end

  def report
    add_crumb "Отчёт"

    @created_at_total = set_filter_param(true, :created_at_total, :boolean)
    @created_at_start = set_filter_param(Date.today-1.month, :created_at_start, :date)
    @created_at_stop = set_filter_param(Date.today, :created_at_stop, :date)
    #@accepted_at_start = set_filter_param(Date.today-1.month, :accepted_at_start, :date)
    #@accepted_at_stop = set_filter_param(Date.today, :accepted_at_stop, :date)
    user_id = params[:user_id]
    user = User.find(user_id)
    @webmaster_id = set_filter_param((user.class==Webmaster) ? user.id : nil, :webmaster, :id)
    @advertiser_id = set_filter_param((user.class==Advertiser) ? user.id : nil, :advertiser, :id)
    @ground_id = set_filter_param(nil, :ground, :id)
    @offer_id = set_filter_param(nil, :offer, :id)
    @sub_id = set_filter_param(nil, :sub_id, :text)
    @group_by = set_filter_param(:date, :group_by, :symbol)

    ct_start = date2time(@created_at_start)
    ct_stop =  date2time(@created_at_stop)+1.day-1.second
    #at_start = date2time(@accepted_at_start)
    #at_stop =  date2time(@accepted_at_stop)+1.day-1.second

    cond = {}
    unless @created_at_total
      cond[:created_at] = {'$gte' => ct_start, '$lte' => ct_stop}
    end

    cond[:webmaster_id] = @webmaster_id if @webmaster_id
    cond[:advertiser_id] = @advertiser_id if @advertiser_id
    cond[:offer_id] = @offer_id if @offer_id
    cond[:ground_id] = @ground_id if @ground_id
    cond[:state] = @state if @state

    @achievements_data = Achievement.group_by(@group_by, :sum => %w[webmoster_amount_сents advertiser_amount_сents], :cond => cond, :sort_desc => [:_id])
  end
	
	protected

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

	def find_nested_objects
		@user = User.find(params[:user_id])
	end

	def and_crumbs
		add_crumb "Пользователи", users_path
		add_crumb "Пользователь «#{@user.email}»", user_path(@user)
		add_crumb "Достижения целей", user_achievements_path(@user)
	end

end
