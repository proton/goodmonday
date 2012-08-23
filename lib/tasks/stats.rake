namespace :stats do
	task :fill => :environment do
		Offer.accepted.each do |offer|
			total_clicks = 0
			total_income = 0
			offer.ground_offers.each do |ground_offer|
				total_time = Time.utc(0)
				cond = {:date => total_time, :offer_id => offer.id, :ground_id => ground_offer.ground_id}
        stats = StatCounter.group_by(%w[income clicks], :date, cond)

				unless stats.empty?
					stat = stats.first

					clicks = stat['clicks_count'].to_i
          income = stat['income_count'].to_i

					total_clicks += clicks
          total_income += income

					ground_offer.clicks = clicks
					ground_offer.payments = Money.new(income)
					epc = income.to_f / clicks
					ground_offer.epc = Money.new(epc) unless epc.nan?
          ground_offer.save
				end
			end
			total_epc = total_income.to_f / total_clicks
			offer.clicks = total_clicks
			offer.payments = Money.new(total_income)
			offer.epc = Money.new(total_epc) unless total_epc.nan?
			offer.save
		end
	end
end