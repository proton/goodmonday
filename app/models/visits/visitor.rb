class Visitor
  include Mongoid::Document
	include Mongoid::Timestamps
	embeds_many :page_visits
	belongs_to :ground
	belongs_to :offer
	has_many :achievements
	has_many :suspicions

	field :advert_id, type: BSON::ObjectId

	field :initial_page, type: String
	field :initial_ip, type: String
  field :user_agent, type: String
  field :sub_id, type: String
end
