# coding: utf-8

class Admin::DebtorsController < Admin::BaseController

	def index
    @users = User.collection.find({'$where' => 'this.hold_balance < this.overdraft', '_type' => 'Advertiser'})
		add_crumb "Должники"
	end
end
