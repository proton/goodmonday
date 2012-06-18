Cpa::Application.routes.draw do
  mount ImperaviRails::Engine => "/imperavi"

  devise_for :users, :path_names =>
	{
		:sign_in => 'login',
		:sign_out => 'logout',
		:password => 'secret',
		:confirmation => 'verification',
		:unlock => 'unblock',
		:registration => 'register'
	}, :controllers => { :registrations => "my/registrations" }
              
  constraints :subdomain => "r" do
    match ':ground_id/rotator' => 'robot#rotator'
    match ':ground_id/advert' => 'robot#advert'
    match ':ground_id/advert/:offer_id' => 'robot#advert'
    match ':ground_id/goto/:offer_id' => 'robot#redirect'
    match ':ground_id/goto/:offer_id/:advert_id' => 'robot#redirect'
    match ':offer_id/visit' => 'robot#visit'
    match ':offer_id/target/:target_id' => 'robot#target'
    match ':offer_id/target/:target_id/:order_id' => 'robot#target'
  end

	constraints :subdomain => "my" do
	  scope :module => "my" do
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
      resources :payments
      resources :stats
			resources :discussions do
				post :message
				put :close
      end
      resource :profile
	  end
	end

	constraints :subdomain => "admin" do
	  scope :module => "admin" do
			match '/' => 'base#index'
			resources :moderations do
				get :accept
				get :deny
			end
			resources :suspicions do
				get :block
				get :forgive
			end
			resources :discussions do
				post :message
				put :close
			end
			resources :users do
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
				resources :grounds
			end
      resources :articles
      resources :news
      resources :debtors
	  end
	end

  resources :articles
  resources :news
  resources :offers

	root :to => 'home#index'
end
