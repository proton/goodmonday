namespace :achievements do
	task :confirm => :environment do
		require 'hpricot'
	 	require 'open-uri'

		Achievement.pending.each do |achievement|
			unless achievement.order_id
				#exception
			end
			order_id = achievement.order_id
			offer = achievement.offer
			target = offer.targets.find(achievement.target_id)
			url = target.confirm_url
			if url.include? '?'
				url = "#{url}&targets=#{order_id}"
			else
				url = "#{url}?targets=#{order_id}"
			end
			doc = Hpricot(open(url))

			(doc/:item).each do |item|
				id = item.at('id').inner_text
				if id==order_id
					status = item.at('status').inner_text.to_i
					price = item.at('price').inner_text.to_f

					if [1,3].include? status
						if status==1
							achievement.state = :accepted
							achievement.price = target.fixed_price + target.prc_price*price/100

              #collecting statistic:
              StatCounter.find_or_create_by(ground_id: achievement.ground_id, offer_id: achievement.offer_id, advertiser_id: achievement.advertsiter_id, webmaster_id: achievement.webmaster_id, date: Date.today, sub_id: achievement.sub_id, target_id: achievement.target_id).inc(:targets, 1)
              StatCounter.find_or_create_by(ground_id: achievement.ground_id, offer_id: achievement.offer_id, advertiser_id: achievement.advertsiter_id, webmaster_id: achievement.webmaster_id, date: Date.new(0), sub_id: achievement.sub_id, target_id: achievement.target_id).inc(:targets, 1)
              StatCounter.find_or_create_by(ground_id: achievement.ground_id, offer_id: achievement.offer_id, advertiser_id: achievement.advertsiter_id, webmaster_id: achievement.webmaster_id, date: Date.today, sub_id: achievement.sub_id, target_id: achievement.target_id).inc(:income, achievement.price)
              StatCounter.find_or_create_by(ground_id: achievement.ground_id, offer_id: achievement.offer_id, advertiser_id: achievement.advertsiter_id, webmaster_id: achievement.webmaster_id, date: Date.new(0), sub_id: achievement.sub_id, target_id: achievement.target_id).inc(:income, achievement.price)
						elsif status==3
							achievement.state = :denied
						end
						achievement.save
					end
				end
			end
		end
	end
end
