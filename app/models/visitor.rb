class Visitor
  include Mongoid::Document
	include Mongoid::Timestamps
	embeds_many :page_visits
	belongs_to :ground
	belongs_to :offer

	field :banner_id, type: BSON::ObjectId

	field :initial_page, type: String
	field :initial_ip, type: String
end
