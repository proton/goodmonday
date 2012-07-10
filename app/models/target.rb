class Target
	include Mongoid::Document
	include Mongoid::Symbolize
	embedded_in :offer

	has_many :achievements

	field :title, type: String
  field :fixed_price, type: Integer, default: 0
  field :fixed_prices_bronze, type: Integer, default: 0
  field :fixed_prices_silver, type: Integer, default: 0
  field :fixed_prices_gold, type: Integer, default: 0

  field :prc_price, type: Integer, default: 0
  field :prc_prices_bronze, type: Integer, default: 0
  field :prc_prices_silver, type: Integer, default: 0
  field :prc_prices_gold, type: Integer, default: 0

  def webmaster_price(price = nil)
    if price && self.confirm_mode==:manual
      self.fixed_prices_bronze + self.prc_prices_bronze*price/100
    else
      self.fixed_prices_bronze
    end
  end

  def advertiser_price(price = nil)
    if price && self.confirm_mode==:manual
      self.fixed_price + self.prc_price*price/100
    else
      self.fixed_price
    end
  end

	symbolize :confirm_mode, :in => [:auto, :manual], :default => :auto
	field :confirm_url, type: String
  field :hold, type: Integer, default: 20

  validates :hold, presence: true

	MODERATED_ATTRS = %w[title fixed_price prc_price hold]
  MODERATED_ATTRS_INFO = {'fixed_price' => {:type => :currency} }
  #MODERATED_EDIT_FIELDS = [:fixed_prices_bronze, :fixed_prices_silver, :fixed_prices_gold, :prc_prices_bronze, :prc_prices_silver, :prc_prices_gold]
  MODERATED_EDIT_FIELDS = [:fixed_prices_bronze, :prc_prices_bronze]
	include IsModerated
end
