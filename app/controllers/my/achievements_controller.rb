# coding: utf-8

class My::AchievementsController < My::BaseController

	def index
		@achievements = current_user.achievements
		add_crumb "Достижения целей"
	end

	def show
		@achievement = Achievement.find(params[:id])
		add_crumb "Достижения целей", my_achievements_path
		add_crumb "Достижение"
	end

end
