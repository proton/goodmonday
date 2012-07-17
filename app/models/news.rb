class News
  include Mongoid::Document
 	include Mongoid::Timestamps

 	field :title, :type => String, :default => ''
 	field :content, :type => String, :default => ''
end
