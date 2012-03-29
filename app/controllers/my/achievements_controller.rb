# coding: utf-8

class My::AchievementsController < My::BaseController

	def index
		@achievements = current_user.achievements
	end

	def show
		@achievement = Achievement.find(params[:id])
	end

end
