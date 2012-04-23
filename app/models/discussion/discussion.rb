class Discussion
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Symbolize

	symbolize :state, :in => [:open, :closed], :default => :open

	auto_increment :num

	belongs_to :user

	embeds_many :messages, cascade_callbacks: true
	accepts_nested_attributes_for :messages

	field :subject, type: String, default: ''
end
