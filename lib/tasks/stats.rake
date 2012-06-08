namespace :stats do
	task :fill => :environment do
		Offer.accepted.each do |offer|
      total_clicks = 0
      total_income = 0
			offer.ground_offers.each do |ground_offer|
        total_time =  Time.utc(0)
        cond = {:date => total_time, :offer_id => offer.id, :ground_id => ground_offer.ground_id}
        func = "function(obj,prev) { prev.click_count += obj.clicks; prev.target_count += obj.targets; prev.income_count += obj.income}"
        h = {key: :date, cond: cond, initial: {click_count: 0, target_count: 0, income_count: 0}, reduce: func}
        stats = StatCounter.collection.group(h)
        next if stats.size==0
        stat = stats.first
        clicks = stat[:clicks]
        income = stat[:income]
        epc = income.to_f / clicks
        total_clicks += clicks
        total_income += income
        ground_offer.clicks = clicks
        ground_offer.payments = income
        ground_offer.epc = epc
        ground_offer.save
      end
      total_epc = total_income.to_f / total_clicks
      offer.clicks = total_clicks
      offer.payments = total_income
      offer.epc = total_epc
      offer.save
		end
  end

end
