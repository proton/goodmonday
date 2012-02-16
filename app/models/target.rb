class Target
  include Mongoid::Document
	embedded_in :offer
end
