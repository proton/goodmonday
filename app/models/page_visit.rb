class PageVisit
  include Mongoid::Document
	include Mongoid::Timestamps::Created
	embedded_in :visitor

	field :page, type: String
	field :ip, type: String
end
