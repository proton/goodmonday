Webmaster.delete_all
Advertiser.delete_all
Ground.delete_all
Offer.delete_all
Visitor.delete_all
Achievement.delete_all
Category.delete_all

category_names = ['Без категории', 'Авто, мото', 'Безопасность', 'Бизнес и экономика', 'Государство и общество', 'Досуг, развлечения', 'Женский клуб', 'Красота и здоровье', 'Мода и стиль', 'Закон и право', 'Интернет, связь', 'Культура и искусство', 'Личные финансы', 'Медицина', 'Наука', 'Компьютерные игры', 'Недвижимость', 'Непознанное', 'Новости и СМИ', 'Образование', 'Путешествия', 'Подросткам и детям', 'Работа и карьера', 'Религия', 'Непознанное', 'Семья и быт', 'Спорт', 'Справки', 'Строительство и ремонт', 'Торговля', 'Транспорт, перевозки', 'Электронная техника']

category_names.each do |category_name|
	Category.create(:title => category_name)
end

webmaster = Webmaster.create(:email => 'webmaster@example.com', :password => '123456', :password_confirmation => '123456')
ground = webmaster.grounds.create(:mode => :automatic, :url => 'proton.name')
advertiser = Advertiser.create(:email => 'advertiser@example.com', :password => '123456', :password_confirmation => '123456')
offer = advertiser.offers.create(:title => 'Test Offer')
target = offer.targets.create(:title => 'Test Target', :price => 100)
advert = offer.adverts.create({url: 'http://regerfest.ru'}, Banner)