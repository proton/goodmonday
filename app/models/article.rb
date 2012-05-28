class Article
  include Mongoid::Document
 	include Mongoid::Timestamps
 	include Mongoid::Activity
 	include Mongoid::Slug

 	field :title, :type => String
 	slug :title
 	field :content, :type => String
end
