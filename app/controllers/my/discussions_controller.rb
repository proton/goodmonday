# coding: utf-8

class My::DiscussionsController < My::BaseController
	before_filter :and_crumbs

	def index
		if current_user.class==Operator
			@discussions = Discussion.open
		else
			@discussions = current_user.discussions
		end
	end

	def show
		@discussion = Discussion.find(params[:id])
		add_crumb "Дискуссия №#{@discussion.num}"
	end

	def new
		add_crumb "Новая дискуссия"
		@discussion = Discussion.new
		@message = @discussion.messages.new
	end

	def create
		@discussion = Discussion.new(params[:discussion])
		@discussion.user = current_user
		@discussion.messages.first.user = current_user
		flash[:notice] = 'Вопрос добавлен.' if @discussion.save
		respond_with(@discussion, :location => my_discussion_path(@discussion))
	end

	def message
		@discussion = Discussion.find(params[:discussion_id])
		@message = @discussion.messages.new
		@message.text = params[:text]
		@message.user = current_user
		flash[:notice] = 'Сообщение добавлено.' if @message.save
		respond_with(@message, :location => my_discussion_path(@discussion))
	end

	def close
		@discussion = Discussion.find(params[:discussion_id])
		flash[:notice] = 'Вопрос закрыт.' if @discussion.update_attribute(:state, :closed)
		respond_with(@discussion, :location => my_discussion_path(@discussion))
	end

	private

	def and_crumbs
		add_crumb 'Дискуссии', my_discussions_path
	end

end
