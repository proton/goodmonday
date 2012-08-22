# coding: utf-8

class Admin::UsersController < Admin::BaseController
	before_filter :find_object, :only => [:show, :update, :edit, :destroy]
	before_filter :and_crumbs, :only => [:show, :edit]

	def index
		@users = User.all
    if params[:type] && !params[:type].empty?
      @users = @users.where(_type: params[:type])
    end
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

  def block
    @user = User.find(params[:user_id])
    if params[:unblock] && !params[:unblock].empty?
      flash[:notice] = 'Пользователь разблокирован.' if @user.update_attributes(blocked: false)
    else
      flash[:notice] = 'Пользователь заблокирован.' if @user.update_attributes(blocked: true)
    end
    redirect_to user_path(@user)
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
