# coding: utf-8

namespace :referral do
	task :pay_reward => :environment do
    Webmaster.where(:total_payments_cents.gt => 4000*100, :blocked => false, :referral_reward_paid => false).each do |webmaster|
			affiliator = webmaster.affiliator
      next unless affiliator
      affiliator_amount = Money.new(500*100)
      if affiliator.referral_pay(affiliator_amount, :reward)
        webmaster.update_attribute(:referral_reward_paid, true)
      end
		end
	end
end