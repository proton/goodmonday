# coding: utf-8

class Admin::AchievementCollectionStatusesController < Admin::BaseController

	def index
    add_crumb "Статусы задач сбора достижений целей", achievement_collection_statuses_path
    @achievement_collection_statuses = AchievementCollectionStatus.desc(:created_at)
	end

end
