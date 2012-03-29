class RobotController < ApplicationController

	def rotator
		@ground = Ground.find(params[:ground_id])
		render :nothing => true, :status => whatever unless @ground
	end

	def advert
		@size = params[:size]
		@ground = Ground.find(params[:ground_id])
		if @ground
			offers = @ground.accepted_offers.for_advert_size(@size)
			offers_count = offers.count
			if offers_count>0
				n = case Random.rand(6)
					when 0 then 0
					when 1 then Random.rand([offers_count, 3].min)
					when 2 then Random.rand([offers_count, 5].min)
					when 3 then Random.rand([offers_count, 10].min)
					when 4 then Random.rand([offers_count, 50].min)
					else Random.rand(offers_count)
				end
				@offer = offers.skip(n).limit(1)
				#
				#@offer = (params[:offer_id])? Offer.find(params[:offer_id]) : @ground.accepted_offers.first
				#@entry = Entry.skip(rand(Entry.count)).limit(1)
				adverts = @offer.adverts.for_size(@size)
				@advert = Random.rand(offers.count).skip(Random.rand(adverts.count)).limit(1)
				@offer.inc(:shows, 1)
				render :text => @advert.html_code(size)
			else
				render :text => Advert.html_code(size)
			end
		else
			render :text => Advert.html_code(size)
		end
	end

	def redirect
		ip = request.remote_ip
		if BlackIp.exclude(ip)
			ground = Ground.find(params[:ground_id])
			if ground
				offer = Offer.find(params[:offer_id])
				if offer
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
		response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
		response.headers["Pragma"] = "no-cache"
		response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
		redirect_to "/pixel.png", :status => 307
	end

	def target
		ip = request.remote_ip
		if BlackIp.exclude(ip)
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

end