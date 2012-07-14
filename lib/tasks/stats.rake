namespace :stats do
	task :fill => :environment do
		Offer.accepted.each do |offer|
			total_clicks = 0
			total_income = 0
			offer.ground_offers.each do |ground_offer|
				total_time =  Time.utc(0)
				cond = {:date => total_time, :offer_id => offer.id, :ground_id => ground_offer.ground_id}
				click_func = "function(obj,prev) { prev.click_count += obj.clicks}"
				click_h = {key: :date, cond: cond, initial: {click_count: 0}, reduce: click_func}
				click_stats = StatClickCounter.collection.group(click_h)
				target_func = "function(obj,prev) { prev.income_count += obj.income}"
				target_h = {key: :date, cond: cond, initial: {income_count: 0}, reduce: target_func}
				target_stats = StatTargetCounter.collection.group(target_h)

				unless click_stats.empty?
					stat = click_stats.first
					clicks = stat[:click_count].to_i
					total_clicks += clicks
					ground_offer.clicks = clicks
				end

				unless target_stats.empty?
					stat = target_stats.first
					income = stat[:income_count].to_i
					total_income += income
					ground_offer.payments = income
				end

				unless click_stats.empty? || target_stats.empty?
					epc = income.to_f / clicks
					ground_offer.epc = epc
				end

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