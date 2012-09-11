class Article
  include Mongoid::Document
 	include Mongoid::Timestamps
 	include Mongoid::Slug

 	field :title, :type => String
 	slug :title
  field :content, :type => String
  field :show_in_menu, :type => Boolean, :default => false

  validates_presence_of :title

  field :active, type: Boolean, default: true
  index :active
  scope :active, where(active: true)
  def active?
    self.active
  end
end
