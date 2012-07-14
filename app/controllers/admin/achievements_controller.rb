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
	
	protected

	def find_nested_objects
		@user = User.find(params[:user_id])
	end

	def and_crumbs
		add_crumb "Пользователи", users_path
		add_crumb "Пользователь «#{@user.email}»", user_path(@user)
		add_crumb "Достижения целей", achievements_path(@user)
	end

end
