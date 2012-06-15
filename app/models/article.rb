class Article
  include Mongoid::Document
 	include Mongoid::Timestamps
 	include Mongoid::Activity
 	include Mongoid::Slug

 	field :title, :type => String
 	slug :title
  field :content, :type => String
  field :show_in_menu, :type => Boolean, :default => false

  validates_presence_of :title
end
