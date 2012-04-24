# coding: utf-8

class Admin::UsersController < Admin::BaseController
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@users = User.all
		add_crumb "Пользователи"
	end

	def create
		@user = User.new(params[:user])
		flash[:notice] = 'Пользователь добавлен.' if @user.save
		respond_with(@user, :location => users_path)
	end

	def update
		flash[:notice] = 'Пользователь обновлён.' if @user.update_attributes(params[:user])
		respond_with(@user, :location => users_path)
	end

	def destroy
		flash[:notice] = 'Пользователь удалён.' if @user.destroy
		respond_with(@user, :location => users_path)
	end

	def new
		@user = User.new
		add_crumb "Пользователи", users_path
		add_crumb "Новый пользователь"
	end

	protected

	def find_object
		@user = User.find(params[:id])
	end

	def and_crumbs
		add_crumb "Пользователи", users_path
		add_crumb "Пользователь «#{@user.email}»"
	end
end
