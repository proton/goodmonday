# coding: utf-8

class Admin::DebtorsController < Admin::BaseController

	def index
    user_ids = User.collection.find({'$where' => 'this.hold_balance_cents < this.overdraft_cents', '_type' => 'Advertiser'}).collect{|e| e['_id']} #TODO: it temporary hack for mongoid3 (collection.find now returns array of Moped::BSON::Document (in 2 version it returns array of Models))
    @users = User.find(user_ids)
		add_crumb "Должники"
	end
end
