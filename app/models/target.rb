class Target
	include Mongoid::Document
	include Mongoid::Symbolize
  include Mongoid::MoneyField
	embedded_in :offer

	has_many :achievements

	field :title, type: String
  field :repeatable, type: Boolean, default: false
  
  money_field :fixed_price
  money_field :fixed_prices_bronze

  field :prc_price, type: Float, default: 0.0
  field :prc_prices_bronze, type: Float, default: 0.0

	symbolize :confirm_mode, :in => [:auto, :manual], :default => :auto
	field :confirm_url, type: String
  field :hold, type: Integer, default: 20

  field :cookieless_achievement, type: Boolean, default: false
  field :achievement_task_marker, type: String

  validates :hold, presence: true

  def webmaster_price(price = nil)
    if price && self.confirm_mode==:manual
      self.fixed_prices_bronze + Money.new(self.prc_prices_bronze*price) #тут умножаем на сто (приводим к копейкам) и делим на сто (ибо проценты)
    else
      self.fixed_prices_bronze
    end
  end

  def advertiser_price(price = nil)
    if price && self.confirm_mode==:manual
      self.fixed_price + Money.new(self.prc_price*price) #тут умножаем на сто (приводим к копейкам) и делим на сто (ибо проценты)
    else
      self.fixed_price
    end
  end

	MODERATED_ATTRS = %w[title fixed_price_cents prc_price hold]
  MODERATED_ATTRS_INFO = {'fixed_price_cents' => {:type => :money} }
  MODERATED_EDIT_FIELDS = [:fixed_prices_bronze, :prc_prices_bronze]
	include IsModerated
end
