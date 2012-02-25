Webmaster.delete_all
Advertiser.delete_all
Ground.delete_all
Offer.delete_all
Visitor.delete_all
Achievement.delete_all

webmaster = Webmaster.create(:email => 'webmaster@example.com', :password => '123456', :password_confirmation => '123456')
ground = webmaster.grounds.create(:mode => :automatic, :url => 'proton.name')
advertiser = Advertiser.create(:email => 'advertiser@example.com', :password => '123456', :password_confirmation => '123456')
offer = advertiser.offers.create(:title => 'Test Offer')
target = offer.targets.create(:title => 'Test Target', :price => 100)
advert = offer.adverts.create({url: 'http://regerfest.ru'}, Banner)