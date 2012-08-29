# coding: utf-8

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

    task :topshop => :environment do
      offer = find_marked_offer('topshop')
      next unless offer
      target = find_marked_target(offer, 'topshop_order')
      next unless target

      require 'hpricot'
      require 'open-uri'

      url = "http://www.top-shop.ru/affiliates/report/23916/7e22c6e6976eab5018024fb2a11e9c6d"

      doc = Hpricot(open(url))
      (doc/:payment_list/:payment).each do |item|
        #
        order_id = item.at('order_id').inner_text
        marker = item.at('key').inner_text
        state = item.at('status').inner_text
        price = item.at('reward').inner_text.to_f
        advertiser_price = Money.new(price*100) #переводим в копейки
        webmaster_price = advertiser_price*0.7
        achievement = offer.achievements.where(:order_id => order_id).first
        if achievement
          if state=='20' && achievement.state!=:accepted
            achievement.accept(webmaster_price, advertiser_price)
            achievement.save
          elsif state=='30' && achievement.state!=:denied
            achievement.cancel!
            achievement.save
          end
        else
          visitor_id = marker.split('?visitor=').second
          next unless visitor_id
          visitor = Visitor.find(visitor_id)
          achievement = Achievement.new
          achievement.build_prototype(offer, visitor, target.id)
          achievement.order_id = order_id
          if state=='20'
            achievement.accept(webmaster_price, advertiser_price)
          elsif state=='30'
            achievement.cancel!
          end
          achievement.created_at = DateTime.parse(item.at('date').inner_text+' +0400')
          achievement.save
        end
      end
    end

    task :domadengi => :environment do
      offer = find_marked_offer('domadengi')
      next unless offer
      target = find_marked_target(offer, 'domadengi_order')
      next unless target

      require 'hpricot'
      require 'open-uri'

      url = "http://secure.domadengi.ru/partner/xml/5194c858bdf337b3bdb1b4b5fb507d97/report.xml"

      doc = Hpricot(open(url))
      (doc/:item).each do |item|
        #
        order_id = item.at('id_cron').inner_text
        state = item.at('status').inner_text
        price = item.at('price').inner_text.to_f
        achievement = offer.achievements.where(:order_id => order_id).first
        if achievement
          if state=='Займ одобрен' && achievement.state!=:accepted
            achievement.accept(target.webmaster_price(price), target.advertiser_price(price))
            achievement.save
          elsif state=='Отказ' && achievement.state!=:denied
            achievement.cancel!
            achievement.save
          end
        else
          visitor_id = item.at('manager_name').inner_text
          next unless visitor_id
          next if visitor_id.empty?
          visitor = Visitor.where(:_id => visitor_id).first
          next unless visitor
          #
          achievement = Achievement.new
          achievement.build_prototype(offer, visitor, target.id)
          achievement.order_id = order_id
          if state=='Займ одобрен'
            achievement.accept(target.webmaster_price(price), target.advertiser_price(price))
          elsif state=='Отказ'
            achievement.cancel!
          end
          achievement.created_at = DateTime.parse(item.at('timestamp_x').inner_text+' +0400')
          achievement.save
        end
      end
    end

    task :aforex => :environment do
      offer = find_marked_offer('aforex')
      next unless offer
      target = find_marked_target(offer, 'aforex_record')
      next unless target

      require 'hpricot'
      require 'mechanize'

      agent = Mechanize.new
      url = 'https://www.aforex.ru/sign_in'
      agent.get(url)
      form = agent.page.forms.first
      form["session[email]"] = 'psavichev@gmail.com'
      form["session[password]"] = 'Tk36KX7A'
      form.submit

      (1..14).each do |d|
        date = (Date.yesterday-d.days).to_s
        url = "https://www.aforex.ru/partner/rewards/index.xml?aggregator=1&from=#{date}&to=#{date}"

        doc = Hpricot(agent.get_file(url))
        (doc/:records/:record).each do |item|
          client_login = item.at('client-login').inner_text
          order_id = "#{client_login}_#{date}"
          price = item.at('reward').inner_text.to_f
          next if price==0
          achievement = offer.achievements.where(:order_id => order_id).first
          unless achievement
            visitor_id = item.at('utmcct').inner_text
            next unless visitor_id
            next if visitor_id.empty?
            visitor = Visitor.where(:_id => visitor_id).first
            next unless visitor
            #
            achievement = Achievement.new
            achievement.build_prototype(offer, visitor, target.id)
            achievement.order_id = order_id
            achievement.additional_info = item
            advertiser_price = Money.new(price*100*29) #переводим из долларов в центы, а из центов - в копейки (по курсу 29) #TODO: исправить фиксированный курс валюты
            webmaster_price = advertiser_price*0.7
            achievement.accept(webmaster_price, advertiser_price)
            #
            achievement.save
          end
        end
      end
    end

    task :nikitaonline => :environment do
      offers = {}
      offers[3] = find_marked_offer('nikitaonline_dom3')
      offers[9] = find_marked_offer('nikitaonline_sphere')
      offers[34] = find_marked_offer('nikitaonline_rappelz')
      offers[40] = find_marked_offer('nikitaonline_4story')
      offers[42] = find_marked_offer('nikitaonline_dragononline')
      offers[44] = find_marked_offer('nikitaonline_fantazium')
      offers[48] = find_marked_offer('nikitaonline_karos')
      offers[54] = find_marked_offer('nikitaonline_kok')
      #offers[503] = find_marked_offer('nikitaonline') #Lost Magic

      targets = {}
      offers.each do |key, offer|
        targets[key] = find_marked_target(offer, 'nikitaonline_payments') if offer
      end

      require 'hpricot'
      require 'open-uri'
      require 'digest/md5'

      uid = '8504521'
      pwd = 'j8ti48r'
      date_from = (Date.today-1.month).to_s
      date_to = Date.yesterday.to_s
      hash = Digest::MD5.hexdigest(uid+Digest::MD5.hexdigest(pwd)+date_from+date_to)
      url = "http://shop.nikitaonline.ru/xml/refstat_partner_xml.php?stat=payments&dfrom=#{date_from}&dto=#{date_to}&pid=all&parent_uid=#{uid}&format=xml&groupby_days=1&groupby_pids=1&md5=#{hash}"

      doc = Hpricot(open(url))
      (doc/:stats/:stat).each do |item|
        #
        visitor_id = item.at('external_key').inner_text
        day = item.at('day').inner_text
        sum = item.at('sum').inner_text.to_f
        order_id = visitor_id.to_s+'='+day
        pid = item.at('pid').inner_text.to_i

        offer = offers[pid]
        next unless offer
        target = targets[pid]
        next unless target

        next if sum==0.0

        achievement = offer.achievements.where(:order_id => order_id).first
        next if achievement

        next unless visitor_id
        next if visitor_id.empty?
        visitor = Visitor.where(:_id => visitor_id).first
        next unless visitor

        achievement = Achievement.new
        achievement.build_prototype(offer, visitor, target.id)
        achievement.order_id = order_id
        achievement.accept(target.webmaster_price(sum), target.advertiser_price(sum))
        achievement.created_at = DateTime.parse(day)
        achievement.save
      end
    end

    task :sapato => :environment do
      offer = find_marked_offer('sapato')
      next unless offer
      target = find_marked_target(offer, 'sapato_order')
      next unless target

      require 'hpricot'
      require 'open-uri'
      require 'net/http'

      target.achievements.pending.each do |achievement|
    			next unless achievement.order_id
    			order_id = achievement.order_id

          params = {'xml' => "<?xml version='1.0'?><items><item>#{order_id}</item></items>"}
          url = "http://www.sapato.ru/rest/marketing/?partner=goodmonday"
          uri = URI.parse(url)
          resp = Net::HTTP.post_form(uri, params)
    			doc = Hpricot(resp.body)

    			(doc/:items/:item).each do |item|
    				id = item.at('id').inner_text
    				if id==order_id
    					status = item.at('status').inner_text.to_i
    					#price = item.at('price').inner_text.to_f
              #comission = item.at('comission').inner_text.to_f
              currency = item.at('currency').inner_text

              next unless currency=='RUR'

              #1. Сумма оплаченного заказа от 1501 руб. -  вознаграждение 1300 рублей
              #2. Сумма оплаченного заказа  1001 руб. - 1500руб  -  вознаграждение 400 рублей
              #3. Сумма оплаченного заказа от 501 до 1000 руб. -  вознаграждение 200 рублей
              #4. Сумма оплаченного заказа до 500 рублей - вознаграждение 50 рублей. 
              #Ваше вознаграждение - 20% от суммы выплаты веб-мастеру. 

              #https://docs.google.com/document/d/1IF0P6BIBj29j0GOqzfhO_DDQA_y7bJ7rCDEr5ss88X4/edit

              if %w[done-a done-b done-c done-d cancel].include? status
    						if status=='cancel'
                  achievement.cancel!
                else
                  webmaster_price = case status
                    when 'done-a'
                      Money.new(50*100)
                    when 'done-b'
                      Money.new(200*100)
                    when 'done-c'
                      Money.new(400*100)
                    when 'done-d'
                      Money.new(1300*100)
                    end
                  advertiser_price = webmaster_price*1.2
                  achievement.accept(webmaster_price, advertiser_price)
    						end
    						achievement.save
              end
    				end
    			end
    		end
      end

    #task :all => [:aviasales, :topshop, :domadengi, :nikitaonline, :aforex, :sapato]
    task :all => :environment do
      offers = %w[aviasales topshop domadengi nikitaonline aforex sapato]
      offers.each do |t|
        collection_status =  AchievementCollectionStatus.new(:idn => t)
        begin
          Rake::Task["achievements:collect:#{t}"].execute
        rescue
          collection_status.message = $!.inspect
          collection_status.state = :error
        end
        collection_status.save
      end
    end
  end

	task :confirm => :environment do
		require 'hpricot'
	 	require 'open-uri'

    collection_status =  AchievementCollectionStatus.new(:idn => 'achievements:confirm')
    begin
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
          id = item.at('id').inner_text.strip
          if id==order_id
            status = item.at('status').inner_text.strip.to_i
            price = item.at('price').inner_text.strip.to_f

            #1 - :accepted
            #2 - :pending
            #3 - :denied
            if [1,3].include? status
              if status==1
                achievement.accept(target.webmaster_price(price), target.advertiser_price(price))
              elsif status==3
                achievement.cancel!
              end
              achievement.save
            end
          end
        end
      end
    rescue
      collection_status.message = $!.inspect
      collection_status.state = :error
    end
      collection_status.save
    end
  end

  task :pay => :environment do
    Achievement.accepted.unpaid.where(:hold_date.lte => Date.today).each do |achievement|
      achievement.pay unless achievement.webmaster.blocked
    end

  end

end
