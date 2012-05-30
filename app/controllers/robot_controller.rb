# coding: utf-8

class RobotController < ApplicationController
	after_filter :set_access_control_headers, :only => [:advert]

	def rotator
		@ground = Ground.find(params[:ground_id])
		render :nothing => true, :status => whatever unless @ground
	end

	def advert
		sizes = params[:sizes]
		ground = Ground.find(params[:ground_id])
		if sizes.empty? || !ground
			render :json => nil
		else
			#offers = ground.accepted_offers.for_advert_size(@size)
			#offers_count = offers.count
			#if offers_count>0
			#	n = case Random.rand(6)
			#		when 0 then 0
			#		when 1 then Random.rand([offers_count, 3].min)
			#		when 2 then Random.rand([offers_count, 5].min)
			#		when 3 then Random.rand([offers_count, 10].min)
			#		when 4 then Random.rand([offers_count, 50].min)
			#		else Random.rand(offers_count)
			#	end
			#	offer = offers.skip(n).limit(1)
			#	#
			#	#offer = (params[:offer_id])? Offer.find(params[:offer_id]) : ground.accepted_offers.first
			#	#entry = Entry.skip(rand(Entry.count)).limit(1)
			#	adverts = offer.adverts.for_size(size)
			#	advert = Random.rand(offers.count).skip(Random.rand(adverts.count)).limit(1)
			#	offer.inc(:shows, 1)
			#	render :text => @advert.html_code(size)
			#else
			#	render :text => Advert.html_code(size)
			#	end
			#"<img src='http://placehold.it/#{size}' />"

			used_offers = []
			banners = {}
			#
			sizes.each_pair do |size,count_str|
				count = count_str.to_i
				offers = ground.accepted_offers.for_advert_size(size).not_in(_id: used_offers)
				offers_count = offers.count
				if offers_count<count
					offers = ground.accepted_offers.for_advert_size(size)
					offers_count = offers.count
				end
				if offers_count>=count
					max_count = offers_count-count+1

					n = (Math.log(Random.rand, 0.95)).floor % max_count
					offers = offers.skip(n).limit(count)
					banners[size] = []
					offers.each do |offer|
						adverts = offer.adverts.for_size(size)
						advert = adverts.skip(Random.rand(adverts.count)).limit(1).first
						banners[size] << advert.html_code(size)
						used_offers << offer.id
					end
				elsif offers_count>0
					banners[size] = []
					count.times do
						n = (Math.log(Random.rand, 0.95)).floor % offers_count
						offer = offers.skip(n).limit(1).first
						adverts = offer.adverts.for_size(size)
						advert = adverts.skip(Random.rand(adverts.count)).limit(1).first
						banners[size] << advert.html_code(size)
						used_offers << offer.id
					end
				else
					banners[size] = Array.new(count.to_i, Advert.html_code(size))
				end

			end
			#
			#sizes.each_pair do |size,count|
			#	banners[size] = Array.new(count.to_i, "<img src='http://placehold.it/#{size}' />")
			#end
			#
			render :json => banners.to_json
		end
	end

	def redirect
		ground_id = params[:ground_id]
		offer_id = params[:offer_id]

		ip = request.remote_ip
		if BlackIp.exclude(ip) && cheack_for_suspicions(request)
			ground = Ground.find(ground_id)
			if ground
				offer = Offer.find(offer_id)
				if offer && ground.find_offer_permission(offer_id).state==:accepted
					visitor = Visitor.new
					visitor.ground = ground
					visitor.offer = offer
					visitor.initial_ip = ip
					visitor.initial_page = request.referer
					visitor.user_agent = request.user_agent

					if params[:advert_id] && !params[:advert_id].empty?
						advert = offer.adverts.find(params[:advert_id])
						visitor.advert_id = advert.id
						url = advert.url
					else
						url = offer.url
          end

          if params[:sub_id] && !params[:sub_id].empty?
            sub_id = params[:sub_id]
            webmaster = ground.webmaster
            unless webmaster.sub_ids.include? sub_id
              webmaster.sub_ids << sub_id
              webmaster.save
            end
          end

					if visitor.save
						cookies[offer.id.to_s] = { :value => visitor.id.to_s, :expires => 1.month.from_now }
						#:path - The path for which this cookie applies. Defaults to the root of the application.
						#:domain - The domain for which this cookie applies.
						redirect_to url
					end
				end
			end
		end
		#404 или 403
	end

	def visit
		offer = Offer.find(params[:offer_id])
		if cookies[offer.id.to_s] && !cookies[offer.id.to_s].empty?
			visitor_id = cookies[offer.id.to_s]
			visitor = Visitor.find(visitor_id)
			if visitor
				visitor.page_visits.create(:ip => request.remote_ip, :page => request.referer)
			end
		end
		#response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
		#response.headers["Pragma"] = "no-cache"
		#response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
	end

	def target
		ip = request.remote_ip
		if BlackIp.exclude(ip) && cheack_for_suspicions(request)
			offer = Offer.find(params[:offer_id])
			if offer
				if cookies[offer.id.to_s] && !cookies[offer.id.to_s].empty?
					visitor_id = cookies[offer.id.to_s]
					visitor = Visitor.find(visitor_id)
					if visitor && visitor.offer == offer
						target_id = params[:target_id]
						target = offer.targets.find(target_id)
						if target
							if Achievement.where(:visitor_id => visitor_id, :target_id => target_id).size==0
								achievement = Achievement.new
								achievement.webmaster = visitor.ground.webmaster
								achievement.advertiser = offer.advertiser
                achievement.ground = visitor.ground
                achievement.sub_id = visitor.sub_id
								achievement.offer = offer
								achievement.visitor = visitor
								achievement.target_id = target_id
								achievement.ip = ip
								achievement.page = request.referer
								if params[:order_id] && !params[:order_id].empty?
									achievement.order_id = params[:order_id]
								end
								if target.confirm_mode == :auto
									achievement.price = target.fixed_price
									achievement.state = :accepted
								end
								achievement.save
							end
						end
					end
				end
			end
		end
		redirect_to "/pixel.png"
	end

	protected

	def cheack_for_suspicions(request)
		reason = nil
		reason = "#{reason}Пустой referer. " if request.referer.empty?
		reason = "#{reason}Пустой user_agent. " if request.user_agent.empty?
		Suspicion.create(:ip => request.remote_ip, :reason_text => reason) unless reason.nil?
		reason.nil?
	end

	def set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Request-Method'] = '*'
	end

end
