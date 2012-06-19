class AdvertiserProfile
  include Mongoid::Document
	include Mongoid::Symbolize
  embedded_in :advertiser

  #personal
  field :company_name, type: String, default: ''
  field :website, type: String, default: ''
  field :contact_person, type: String, default: ''
  field :contact_phone, type: String, default: ''
  #payments
  symbolize :payment_method, :in => [:webmoney, :cashless], :default => :cashless

  field :wallet_wmr, type: String, default: ''

  field :payment_account, type: String, default: ''
  field :bank_name, type: String, default: ''
  field :correspondent_account, type: String, default: ''
  field :bik, type: String, default: ''
  field :inn, type: String, default: ''
  field :kpp, type: String, default: ''
  field :juridical_address, type: String, default: ''
end
