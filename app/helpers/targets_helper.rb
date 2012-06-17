module TargetsHelper
	def show_target_price(prc_price, fixed_price)
    s = ''
    s+="#{prc_price} %" if prc_price>0
    s+=" + " if prc_price>0 && fixed_price>0
    s+=number_to_rubles(fixed_price) if fixed_price>0
    s
  end
end
