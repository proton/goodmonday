Cpa::Application.routes.draw do
  devise_for :users, :path_names =>
	{
		:sign_in => 'login',
		:sign_out => 'logout',
		:password => 'secret',
		:confirmation => 'verification',
		:unlock => 'unblock',
		:registration => 'register'
	}, :controllers => { :registrations => "my/registrations" }

	match 'robot/:ground_id/rotator' => 'robot#rotator'
	match 'robot/:ground_id/advert' => 'robot#advert'
	match 'robot/:ground_id/advert/:offer_id' => 'robot#advert'
	match 'robot/:ground_id/goto/:offer_id' => 'robot#redirect'
	match 'robot/:ground_id/goto/:offer_id/:advert_id' => 'robot#redirect'
	match 'robot/:offer_id/visit' => 'robot#visit'
	match 'robot/:offer_id/target/:target_id' => 'robot#target'
	match 'robot/:offer_id/target/:target_id/:order_id' => 'robot#target'

	namespace :my do
		match '/' => 'base#index'
		#advertiser
		resources :offers do
			resources :targets
			resources :adverts do
				resources :banner_images
			end
			resources :grounds, :controller => "ground_offers" do
				get :accept
				get :deny
			end
		end
		#webmaster
		resources :grounds do
			resources :links, :controller => "ground_link_offers"
			resources :adverts, :controller => "ground_advert_offers"
		end
		#advertiser & webmaster
		resources :achievements
		#operator
		resources :moderations do
			get :accept
			get :deny
		end
		resources :suspicions do
			get :block
			get :forgive
		end
		#all
		resources :discussions do
			post :message
			put :close
		end
	end

	match "user_root", :to => "my::base#index"

	root :to => 'home#index'
end
