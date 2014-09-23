Rails.application.routes.draw do
  root  to: 'home#index'

  devise_for :users

  namespace :api , :defaults => { :format => 'json' } do
    scope :module => :v1 do 
      post 'register', to: 'session#sing_up',  :as => :signup
      post 'login', to: 'session#sing_in', :as => :login
      get 'logout', to: 'session#sing_out' , :as => :logout
      
      post 'forgot_password', to: 'session#forgot_password', :as => :forgot_password
      post 'change_password', to: 'session#change_password', :as => :change_password
       
      post 'update_profile', to: 'user#update_profile', :as => :update_profile
      post 'update_lat_long', to: 'user#update_latitude_longitude', :as => :update_lat_long
      
      post 'create_group', to: 'group#create_group', :as => :create_group
      post 'add_friend_group', to: 'group#add_friends_in_group',  :as => :add_friend_group
      post 'list_groups', to: 'group#groups_list', :as => :list_groups
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
