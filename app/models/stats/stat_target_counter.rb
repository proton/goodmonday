class StatTargetCounter
	include Mongoid::Document

  belongs_to :ground, index: true
  belongs_to :offer, index: true
  belongs_to :user, index: true

  field :date, type: Date
  field :sub_id, type: String
  field :target_id, type: BSON::ObjectId

  field :targets, type: Integer, default: 0
  field :income, type: Integer, default: 0

  index :date
  index :sub_id

  index({ user_id: 1, date: 1 })
end