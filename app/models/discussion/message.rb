# coding: utf-8

class Message
  include Mongoid::Document
	include Mongoid::Timestamps
	embedded_in :discussion

	belongs_to :user

	field :text, type: String
	validates_presence_of(:text)
end
