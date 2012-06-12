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

	def and_crumbs
		add_crumb "Достижения целей", achievements_path
	end

end
