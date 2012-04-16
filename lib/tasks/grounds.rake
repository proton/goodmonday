namespace :grounds do
	task :set_offers => :environment do

		Ground.where(:rotator_mode => :auto).each do |ground|
			config = ground.ground_rotator_config
			offers = Offer.where(:is_adult => !config.block_adult).where(:is_doubtful => !config.block_doubtful)
			offers = offers.not_in(category_id: config.categories) unless config.categories.empty?
			ground.remove_all_rotator_offers
			offers.each do |offer|
				ground.add_rotator_offer(offer)
			end
			ground.save
		end
	end
end
