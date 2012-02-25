class Achievement
    include Mongoid::Document
    include Mongoid::Timestamps
    belongs_to :webmaster
    belongs_to :advertiser
    belongs_to :ground
    belongs_to :offer
    belongs_to :visitor
    field :target_id, type: BSON::ObjectId

    field :page, type: String
    field :ip, type: String
end
