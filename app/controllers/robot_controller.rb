class RobotController < ApplicationController
	def banner
	end

	def redirect
		ip = request.remote_ip
		#check_for_bl
		#линк аля robot/:webmaster_id/redirect/:offer_id/:banner_id
		webmaster = Webmaster.find(params[:webmaster_id])
		#TODO: use webmaster_id
		offer = Offer.find(params[:offer_id])
		if offer
			banner = Offer.adverts.find(params[:banner_id])
			if banner
				url = banner.url
				visitor = Visitor.new
				visitor.offer = offer
				visitor.banner_id = banner.id
				visitor.initial_ip = ip
				visitor.initial_page = request.referer
				if visitor.save
					cookies[offer.id.to_s] = { :value => visitor.id.to_s, :expires => 1.month.from_now }
					#:path - The path for which this cookie applies. Defaults to the root of the application.
					#:domain - The domain for which this cookie applies.
					redirect_to url
				end
			end
		end
		#404 или 403
	end

	def visit
		#линк аля robot/:offer_id/visit
		offer = Offer.find(params[:offer_id])
		unless cookies[offer.id.to_s].empty?
			visitor_id = cookies[offer.id.to_s]
			visitor = Visitor.find(visitor_id)
			if visitor
				visitor.page_visits.create(:ip => request.remote_ip, :page => request.referer)
			end
		end
		#отдаём прозрачный пиксел
	end

	def target
		#TODO: подумать!
	end
end
