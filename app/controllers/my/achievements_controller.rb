# coding: utf-8

class My::AchievementsController < My::BaseController
	before_filter :and_crumbs

	def index
		@achievements = current_user.achievements
	end

	def show
		@achievement = current_user.achievements.find(params[:id])
		add_crumb "Достижение"
	end

	def and_crumbs
		add_crumb "Достижения целей", my_achievements_path
	end

end
