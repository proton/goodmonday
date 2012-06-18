class WebmasterProfile
  include Mongoid::Document
	include Mongoid::Symbolize
  embedded_in :webmaster

  #personal
  field :first_name, type: String, default: ''
  field :last_name, type: String, default: ''
	symbolize :person_state, :in => [:natural, :sole, :artificial], :default => :natural
  field :city, type: String, default: ''
  field :phone, type: String, default: ''
  #payments
  symbolize :payment_method, :in => [:webmoney, :bank], :default => :webmoney

  field :wallet_wmr, type: String, default: ''

  field :recipient_bank, type: String, default: ''
  field :correspondent_account, type: String, default: ''
  field :bik, type: String, default: ''
  field :payment_account, type: String, default: ''
  field :inn, type: String, default: ''

  field :ogrnip, type: String, default: ''
  field :fio, type: String, default: ''

  field :recipient, type: String, default: ''
  field :kpp, type: String, default: ''
  field :juridical_address, type: String, default: ''
  field :physical_address, type: String, default: ''

  #notifications
  field :email_offer_changes, type: Boolean, default: true
  field :email_new_offers, type: Boolean, default: true

  #field :sub_ids, type: Array, default: []

	#symbolize :rank, :in => [:bronze, :silver, :gold], :default => :bronze
end
