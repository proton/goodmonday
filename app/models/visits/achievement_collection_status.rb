# coding: utf-8

class AchievementCollectionStatus
	include Mongoid::Document
	include Mongoid::Timestamps::Created
	include Mongoid::Symbolize

  symbolize :state, :in => [:success, :error], :default => :success, :scopes => true

  field :idn, type: String
 	index :idn
	field :message, type: String
end
