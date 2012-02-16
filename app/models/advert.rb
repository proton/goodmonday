class Advert
  include Mongoid::Document
	embedded_in :offer
end
