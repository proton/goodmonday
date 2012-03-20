# coding: utf-8

class Admin::ModerationsController < Admin::BaseController

	def index
		@moderations = Moderation.all
	end

	def accept
		@moderation = Moderation.find(params[:moderation_id])
		@moderation.accept
		redirect_to admin_moderation_path(@moderation)
	end

	def deny
		@moderation = Moderation.find(params[:moderation_id])
		@moderation.deny
		redirect_to admin_moderation_path(@moderation)
	end
end
