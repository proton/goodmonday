# coding: utf-8

class Admin::NewsController < Admin::BaseController
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@news = News.all
		add_crumb "Новости"
  end

	def create
		@news = News.new(params[:news])
		flash[:notice] = 'Новость добавлена.' if @news.save
		respond_with(@news, :location => news_index_path)
	end

	def update
		flash[:notice] = 'Новость обновлена.' if @news.update_attributes(params[:news])
		respond_with(@news, :location => news_index_path)
	end

	def destroy
		flash[:notice] = 'Новость удалена.' if @news.destroy
		respond_with(@news, :location => news_index_path)
	end

	def new
		@news = News.new
		add_crumb "Новости", news_index_path
		add_crumb "Новая статья"
	end

	protected

	def find_object
		@news = News.find(params[:id])
	end

	def and_crumbs
		add_crumb "Новости", news_index_path
		add_crumb @news.title
	end
end
