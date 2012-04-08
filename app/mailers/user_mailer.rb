# coding: utf-8
class UserMailer < ActionMailer::Base
	default from: "robot@goodmonay.ru"

	def link_offer_removing(user, offer)
		@offer = offer
		mail(:to => user.email, :subject => "Удаление оффера «#{offer.title}»")
	end
end
