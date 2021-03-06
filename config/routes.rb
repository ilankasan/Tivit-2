FirstApp::Application.routes.draw do
  
  
  
  match '/auth/facebook/callback' => 'authentication_services#create'
  match '/auth/google/callback'  => 'authentication_services#create' 
   
  resources :authentication_services, :only => [:index, :create]
  
   
  
  devise_for :accounts, :controllers => {
                          :registrations  => "my_devise/registrations",
                          #:sessions       => "my_devise/sessions",
                          :mailer         => "my_devise/mailer"}
  #resources :account do
  #resources :registrations do
  devise_for :accounts do 
    match "awaiting_confirmation"    => "my_devise/registrations#awaiting_confirmation"
 end
  #end  
  

 
  match "profile_images/:id"    => "profile_images#update"
 
  devise_for :accounts, :controllers => { :sessions => "sessions" }
  
  devise_for :accounts

  resources :profile_images do
  resources :users
end
#root_path
resources :profile_images do
  match "profile_images/:id" 	  => "profile_images#update"
  match "profile_images/:id/edit" => "profile_images#update"
  
  match "/edit" => "profile_images#edit"
  match "/show" => "profile_images#show"
end
resources :documents
  #match "documents/:id"      => "documents#add"
  match "documents/:id/edit" => "documents#update"
  match "documents/new"      => "documents#new"
  match "documents/delete"   => "documents#delete"
  
  
  
  #match "/edit" => "profile_images#edit"
  #match "/show" => "profile_images#show"
    
  resources :activities do
  	
  resources :tivitcomments
  #resources :activities_documents
  resources :documents
end
  resources :tivitcomments

  get "tivitcomments/new"

  resources :users
  
  match "/ajax/autoname"         => "users#autoname"
  
  resources :sessions,   :only => [:new, :create, :destroy]
  #resources :activities, :only => [:create, :destroy, :update, :show, :edit]


  #match '/signin',  :to => 'sessions#new'
  #match '/signout', :to => 'sessions#destroy'

resources :activities
#match '/activities',    :to => 'activities#update'
	  match "activities/:id"  	     => "activities#update"
	  match "/onit" 				         => "activities#on_it"
	  match "/reassign"              => "activities#reassign"
  	match "/decline" 			         => "activities#decline"
  	match "/proposedate" 		       => "activities#propose_date"
  	match "/acceptdate" 		       => "activities#accept_date"
  	match "/remind" 			         => "activities#remind"
  	match "/done" 				         => "activities#done"
  	match "/change_tivit_status"   => "activities#change_tivit_status"
  	match "/new_tivit" 			       => "activities#new_tivit"
  	match "/create_tivit" 		     => "activities#create_tivit"
  	match "/remove_tivit" 		     => "activities#remove_tivit"
  	match "/edit_tivit" 		       => "activities#edit_tivit"
  	match "/mark_as_completed"     => "activities#mark_as_completed"
    match "/completed_activity"    => "activities#completed_activity"
    match "/reopen_completed_activity"    => "activities#reopen_completed_activity"
    
  	match "/update_tivit/:id" 	   => "activities#update_tivit"
  	match "/update_reviewed/:id"   => "activities#update_reviewed"
  	match "/ajax/invitees"         => "users#autoname"
  	# Add by Yaniv 2/19 to enable Edit Activity with Ajax
  	match "activities/:id/edit"                  => "activities#edit"
        	
  
resources :pages  
  match '/about',     :to => 'pages#about'
  match '/home',      :to => 'pages#home'
  match '/bireport',  :to => 'pages#bireport'
  match '/myteam',    :to => 'pages#myteam'
  match '/help',      :to => 'pages#help'
  match '/people',      :to => 'pages#people'
  
  match '/contact',   :to => 'pages#contact'
  match '/myaccount', :to => 'pages#myaccount'
  match '/filter',     :to => 'pages#filter'
  #match '/awaiting_confirmation',      :to => 'pages#awaiting_confirmation'
  match "/home/load_tabs"   => "pages#load_tabs"
  
  
  
resources :users do
  get :autocomplete_user_email, :on => :collection
end

resources :users
  get "users/show"
  #match '/signup',  :to => 'users#new'
  match '/allusers',  :to => 'users#allusers'
  match "users/:id" => "users#update"
  match "users/relationship/:id" => "users#relationship"
  
  	
#resources :activity_documents
  #match "activity_documents/:id" => "activity_documents#add_file"
  #match "activity_documents/:id/edit" => "activity_documents#update"
  #match "activity_documents/new" => "activity_documents#new"
  #match "activities/:id"     => "activities#update"
  
  
  
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
   root :to  => "pages#home"
   #root1 :to => "pages#home1"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
