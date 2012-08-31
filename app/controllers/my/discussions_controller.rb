# coding: utf-8

class My::DiscussionsController < My::BaseController
	before_filter :and_crumbs

	def index
		discussions = current_user.discussions
		@discussions_open = discussions.where(state: :open)
		@discussions_closed = discussions.where(state: :closed)
	end

	def show
		@discussion = Discussion.find(params[:id])
		add_crumb "Дискуссия №#{@discussion.num}: #{@discussion.subject}"
		gon.discussion_id = @discussion.id.to_s
		gon.discussion_last = @discussion.messages.max(:created_at).strftime('%Y-%m-%dT%H:%M:%S')
		gon.url = request.fullpath
		if params[:last] && !params[:last].empty?
			@messages = @discussion.messages.where(:created_at.gt => params[:last]).order_by([:created_at, :asc])
		end
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
		respond_with(@discussion, :location => discussion_path(@discussion))
	end

	def message
		@discussion = Discussion.find(params[:discussion_id])
		@message = @discussion.messages.new
		@message.text = params[:text]
		@message.user = current_user
		flash[:notice] = 'Сообщение добавлено.' if @message.save
		respond_with(@message, :location => discussion_path(@discussion))
	end

	def close
		@discussion = Discussion.find(params[:discussion_id])
		flash[:notice] = 'Вопрос закрыт.' if @discussion.update_attribute(:state, :closed)
		respond_with(@discussion, :location => discussion_path(@discussion))
	end

	private

	def and_crumbs
		add_crumb 'Дискуссии', discussions_path
	end

end
