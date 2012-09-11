# coding: utf-8

class ArticlesController < ApplicationController
	before_filter :find_object, :only => [:show]
	before_filter :and_crumbs, :only => [:show]

	def index
		@articles = Article.active
		add_crumb "Статьи"
	end

	protected

	def find_object
		@article = Article.find(params[:id])
	end

	def and_crumbs
		add_crumb "Статьи", articles_path
		add_crumb @article.title
	end
end
