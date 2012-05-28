# coding: utf-8

class NewsController < ApplicationController
	before_filter :find_object, :only => [:show]
	before_filter :and_crumbs, :only => [:show]

	def index
		@news = News.all
		add_crumb "Статьи"
	end

	protected

	def find_object
		@news = News.find(params[:id])
	end

	def and_crumbs
		add_crumb "Статьи", news_index_path
		add_crumb @news.title
	end
end
