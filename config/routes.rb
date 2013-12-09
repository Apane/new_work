Friendiose::Application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  root to: "home#landing"

  devise_for :users, :controllers => {:registrations => "users/registrations",
    :sessions => "users/sessions",
    :passwords => "users/passwords"}

  get "welcome", to: "home#welcome", as: 'welcome'

  devise_scope :user do
  #  get "edit/edit_account", :to => "devise/registrations#edit_account", :as => "account_registration"
    get 'edit/edit_account' => 'users/registrations#account_registration', as: :edit_account
  end

  # patch '/users/:id', to: 'users#update', as: 'user'
  get 'profile/:id' => "users#show", as: :profile
  get 'disconnect' => 'users#disconnect'

  resources :users do
    resources :questions
  end
  resources :photos
  resources :events
  resources :questions

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
