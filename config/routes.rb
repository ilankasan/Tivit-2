FirstApp::Application.routes.draw do
  
  
  resources :activities do
  resources :tivitcomments
end
  resources :tivitcomments

  get "tivitcomments/new"

  resources :users
  resources :sessions,   :only => [:new, :create, :destroy]
  #resources :activities, :only => [:create, :destroy, :update, :show, :edit]


  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

resources :activities
#match '/activities',    :to => 'activities#update'
	match "activities/:id" => "activities#update"
	match "/accept" => "activities#accept"
  	match "/decline" => "activities#decline"
  	match "/change_tivit_status" => "activities#change_tivit_status"
  	
  	
  	

        
resources :pages  

  #get "users/new"
  
  match '/about',   :to => 'pages#about'
  match '/home',    :to => 'pages#home'
  match '/signout',   :to => 'pages#signout'
    match '/myteam',   :to => 'pages#myteam'
 
  match '/help',    :to => 'pages#help'
   match '/contact', :to => 'pages#contact'
  match '/myaccount', :to => 'pages#myaccount'
  

  get "pages/signout"

  
  
  
  
  resources :users
  get "users/show"
  match '/signup',  :to => 'users#new'
  match '/allusers',  :to => 'users#allusers'
  match "users/:id" => "users#update"
  
  
#  match '/signup',  :to => 'users#new'
 # match '/show',   :to => 'users#show'
  
  
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
   root :to => "pages#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
