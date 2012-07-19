module TargetsHelper
	def show_target_price(prc_price, fixed_price)
    fixed_price_exists = (fixed_price && fixed_price>0)
    prc_price_exists = (prc_price && prc_price.to_f>0)
    s = ''
    s+="#{prc_price} %" if prc_price_exists
    s+=" + " if prc_price_exists && fixed_price_exists
    s+=number_to_currency(fixed_price) if fixed_price_exists
    s
  end
end
