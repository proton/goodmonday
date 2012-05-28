# coding: utf-8

class Admin::ArticlesController < Admin::BaseController
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@articles = Article.all
		add_crumb "Статьи"
  end

	def create
		@article = Article.new(params[:article])
		flash[:notice] = 'Статья добавлена.' if @article.save
		respond_with(@article, :location => articles_path)
	end

	def update
		flash[:notice] = 'Статья обновлена.' if @article.update_attributes(params[:article])
		respond_with(@article, :location => articles_path)
	end

	def destroy
		flash[:notice] = 'Статья удалена.' if @article.destroy
		respond_with(@article, :location => articles_path)
	end

	def new
		@article = Article.new
		add_crumb "Статьи", articles_path
		add_crumb "Новая статья"
	end

	protected

	def find_object
		@article = Article.find_by_slug(params[:id])
	end

	def and_crumbs
		add_crumb "Статьи", articles_path
		add_crumb @article.title
	end
end
