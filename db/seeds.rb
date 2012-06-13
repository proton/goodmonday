#Webmaster.delete_all
#Advertiser.delete_all
#Ground.delete_all
#Offer.delete_all
#Visitor.delete_all
#Achievement.delete_all
Category.delete_all

category_names = ['Автомобили', 'Азартные игры', 'Банки и Финансы', 'Досуг', 'Другое', 'Загрузки', 'Знакомства', 'Игры', 'Интернет-магазины', 'Интернет-решения', 'Информационные товары', 'Красота и здоровье', 'Купоны и скидки', 'Образование', 'Работа и Карьера', 'Развлечения', 'Спорт', 'Строительство и ремонт', 'Туризм и Отдых', 'Услуги', 'Изотерика и Психология']

category_names.each do |category_name|
	Category.create(:title => category_name)
end

#webmaster = Webmaster.create(:email => 'webmaster@example.com', :password => '123456', :password_confirmation => '123456')
#advertiser = Advertiser.create(:email => 'advertiser@example.com', :password => '123456', :password_confirmation => '123456')
#operator = Operator.create(:email => 'operator@example.com', :password => '123456', :password_confirmation => '123456')
#
#ground = webmaster.grounds.create(:mode => :automatic, :url => 'proton.name')
#offer = advertiser.offers.create(:title => 'Test Offer')
#target = offer.targets.create(:title => 'Test Target', :price => 100)
#advert = offer.adverts.create({url: 'http://regerfest.ru'}, Banner)