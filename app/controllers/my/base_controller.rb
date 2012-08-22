# coding: utf-8

class My::BaseController < ApplicationController
	respond_to :html
  before_filter :authenticate_user!
  before_filter :check_for_block
	before_filter :get_user_status
	layout 'my'

	add_crumb 'Кабинет', '/'

	def index
    case current_user.class
      when Advertiser, Webmaster
        @common_stat = current_user.common_stats
      when Operator
        redirect_to moderations_url(:subdomain => :admin)
    end
	end

	protected

	def forbid
		render :status => :forbidden, :text => "Forbidden access"
  end

  def check_for_block
    return if self.controller_name == 'base' && self.action_name == 'index'
    if current_user.class==Webmaster && current_user.blocked
      flash[:error] = 'Аккаунт заблокирован'
      redirect_to root_path
    end
  end

	def get_user_status
		@is_operator = (current_user.class==Operator)
	end
end
