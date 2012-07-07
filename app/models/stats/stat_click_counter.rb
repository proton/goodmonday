class StatClickCounter
	include Mongoid::Document

  belongs_to :ground, index: true
  belongs_to :offer, index: true
  belongs_to :adversiter, index: true
  belongs_to :webmaster, index: true

  field :date, type: Date
  field :sub_id, type: String

  field :clicks, type: Integer, default: 0

  index :date
  index :sub_id

  index({ webmaster_id: 1, date: 1 })
  index({ adversiter_id: 1, date: 1 })
end
