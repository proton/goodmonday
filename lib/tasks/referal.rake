namespace :referal do
	task :pay_reward => :environment do
    Webmaster.where(:total_payments_cents.gt => 4000*100, :blocked => false, :referal_reward_paid => false).each do |webmaster|
			affiliator = webmaster.affiliator
      next unless affiliator
      affiliator_amount = Money.new(500*100)
      affiliator.referal_total_payments += affiliator_amount
      affiliator.save!
      p = affiliator.payments.new(description: 'Перечисление средств по реферальной программе (за активного вебмастера)')
      p.amount = affiliator_amount
      p.save!
      webmaster.update_attribute(:referal_reward_paid, true)
		end
	end
end