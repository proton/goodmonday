# coding: utf-8

class My::ModerationsController < My::BaseOperatorController
	before_filter :find_moderation, :only => [:show, :accept, :deny, :destroy]

	def index
		@moderations = Moderation.all
		add_crumb "Модерации"
	end

	def show
		add_crumb "Модерации", admin_moderations_path
		add_crumb "Модерация объекта #{@moderation.moderated_type}"
	end

	def accept
		@moderation.accept(current_operator, params[:moderated_edit])
		redirect_to admin_moderation_path(@moderation)
	end

	def deny
		@moderation.deny(current_operator)
		redirect_to admin_moderation_path(@moderation)
	end

	protected

	def find_moderation
		id = params[:id] ? params[:id] : params[:moderation_id]
		@moderation = Moderation.find(id)
	end
end
