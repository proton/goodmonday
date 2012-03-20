Cpa::Application.routes.draw do
  devise_for :operators
  devise_for :users, :path_names =>
	{
		:sign_in => 'login',
		:sign_out => 'logout',
		:password => 'secret',
		:confirmation => 'verification',
		:unlock => 'unblock',
		:registration => 'register'
	}

	match 'robot/:ground_id/rotator' => 'robot#advert'
	match 'robot/:ground_id/advert/:size' => 'robot#advert'
	match 'robot/:ground_id/advert/:offer_id' => 'robot#advert'
	match 'robot/:ground_id/goto/:offer_id' => 'robot#redirect'
	match 'robot/:ground_id/goto/:offer_id/:advert_id' => 'robot#redirect'
	match 'robot/:offer_id/visit' => 'robot#visit'
	match 'robot/:offer_id/target/:target_id' => 'robot#target'

	namespace :my do
		match '/' => 'base#index'
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
		resources :grounds do
			resources :links, :controller => "ground_link_offers"
			resources :adverts, :controller => "ground_advert_offers"
		end
	end
	namespace :admin do
		match '/' => 'base#index'
		resources :moderations do
			get :accept
			get :deny
		end
	end

	root :to => 'home#index'
end
