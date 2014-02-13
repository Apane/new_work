Friendiose::Application.routes.draw do
  get "favorites/index"
  resources :messages

  resources :conversations do
    member do
      get :refresh_messages
    end
  end

  # get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')
  get 'pusher/auth' => 'pusher#auth'

  root to: "home#landing"

  devise_for :users, :controllers => {:registrations => "users/registrations",
    :sessions => "users/sessions",
    :passwords => "users/passwords",
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  get "welcome", to: "home#welcome", as: 'welcome'

  # devise_scope :user do
    get 'settings' => 'users#account_registration', as: :settings
  # end

  get 'profile/:id' => "profiles#show", as: :profile
  get 'disconnect' => 'users#disconnect'
  get 'profiles' => "profiles#index"
  get 'sent' => 'messages#sent'
  get 'notifications' => 'notifications#index'
  get 'visitors' => 'users#visitors'
  get 'expand_your_social_circle' => 'seo#expand_your_social_circle'
  get 'find_new_friends' => 'seo#find_new_friends'
  get 'meet_new_people' => 'seo#meet_new_people'
  get 'edit_profile' => 'users#edit_profile'
  get 'favorites' => 'favorites#index'
  get 'toggle_favorite' => 'favorites#toggle_favorite'
  get 'toggle_blocked' => 'users#toggle_blocked'
  get 'toggle_hidden' => 'users#toggle_hidden'
  post 'act_on_conversations' => 'conversations#act_on_conversations'
  get 'activities' => 'events#activities'


  resources :users do
    resources :questions
    # post 'add_favorite', on: :member
    # delete 'destroy_favorite', on: :member
  end

  resources :photos

  resources :events do #events/1/comments
    resources :comments
    post 'attend', on: :member
    delete 'stop_attend', on: :member
  end

  resources :questions

  # resources :favorites



  # duplicates o for devise
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
