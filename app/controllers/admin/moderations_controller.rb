# coding: utf-8

class Admin::ModerationsController < Admin::BaseController
	before_filter :find_moderation, :only => [:show, :accept, :deny, :destroy]

	def index
		moderations = Moderation.desc(:updated_at)
		@moderations_accepted = moderations.accepted
		@moderations_denied = moderations.denied
		@moderations_pending = moderations.pending
		add_crumb "Модерации"
	end

	def show
		add_crumb "Модерации", moderations_path
		add_crumb "Модерация объекта #{@moderation.moderated_type}"
	end

	def accept
		@moderation.accept(current_user, params[:moderated_edit])
		redirect_to moderation_path(@moderation)
	end

	def deny
		@moderation.deny(current_user)
		redirect_to moderation_path(@moderation)
	end

	protected

	def find_moderation
		id = params[:id] ? params[:id] : params[:moderation_id]
		@moderation = Moderation.find(id)
	end
end
