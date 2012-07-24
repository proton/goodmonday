namespace :achievements do
  namespace :collect do

    def find_marked_offer(marker)
      return Offer.where(:achievement_task_marker => marker).first
    end

    def find_marked_target(offer, marker)
      return offer.targets.where(:achievement_task_marker => marker).first
    end

    task :aviasales => :environment do
      offer = find_marked_offer('aviasales')
      next unless offer
      target = find_marked_target(offer, 'aviasales_booking')
      next unless target

      require 'hpricot'
      require 'open-uri'

      url = "http://nano.aviasales.ru/partners/statistics/api.xml?start_time=#{(Date.today-2.months).to_s}T00:00:00&end_time=#{Date.tomorrow.to_s}T00:00:00"
      username = 'perepechenkov@goodmonday.ru'
      password = 'sCg3MCZp'

      doc = Hpricot(open(url, :http_basic_authentication => [username, password]))
      (doc/:bookings/:booking).each do |item|
        order_number = item.at('order-number').inner_text
        marker = item.at('marker').inner_text
        order_id = "#{marker}.#{order_number}"
        state = item.at('state').inner_text
        achievement = offer.achievements.where(:order_id => order_id).first
        if achievement
          next if achievement.is_accepted?
          if state=='paid'
            price = item.at('price').inner_text.to_f
            achievement.accept(target.webmaster_price(price), target.advertiser_price(price))
            achievement.save
          end
        else
          visitor_id = marker.split('.').second
          visitor = Visitor.find(visitor_id)
          achievement = Achievement.new
          achievement.build_prototype(offer, visitor, target.id)
          achievement.order_id = order_id
          if state=='paid'
            price = item.at('price').inner_text.to_f
            achievement.accept(target.webmaster_price(price), target.advertiser_price(price))
          end
          achievement.created_at = DateTime.parse(item.at('booked-at').inner_text+' +0400')
          achievement.save
        end
      end
    end

    task :all => [:aviasales]
  end

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
      next if !url || url.empty?
			if url.include? '?'
				url = "#{url}&targets=#{order_id}"
			else
				url = "#{url}?targets=#{order_id}"
			end
			doc = Hpricot(open(url))

			(doc/:items/:item).each do |item|
				id = item.at('id').inner_text
				if id==order_id
					status = item.at('status').inner_text.to_i
					price = item.at('price').inner_text.to_f

          #1 - :accepted
          #2 - :pending
          #3 - :denied
					if [1,3].include? status
						if status==1
              achievement.accept(target.webmaster_price(price), target.advertiser_price(price))
						elsif status==3
							achievement.state = :denied
						end
						achievement.save
					end
				end
			end
		end
  end

  task :pay => :environment do
    Achievement.accepted.unpaid.where(:hold_date.lte => Date.today).each do |achievement|
      achievement.pay
    end

  end

end
