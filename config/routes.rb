Rails.application.routes.draw do

  # Root
  root to: 'pages#home'

  # Static Pages
  get 'pages/about' => "pages#about"
  get 'pages/contact' => "pages#contact"

  # Scaffolds
  resources :profiles
  resources :applications
  resources :submissions, only: :show, controller: :root_submissions do
    resource :like, module: :root_submissions
  end
  resources :hackathons do
    resources :submissions, except: [:show]
  end

  # Submission Tags
  get 'tags/:tag', to: 'root_submissions#tag', as: :tag

  # Devise
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'register'}

  # API
  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1 do
      get '/user' => "users#show"
      get 'tags/:tag', to: 'submissions#tag', as: :tag
      resources :submissions, only: [:show]
      resources :profiles
      resources :applications
      resources :hackathons do
        resources :submissions, except: [:show, :tag], controller: :submissions
      end
    end
  end

  # Admin Root
    get "/admin" => "admin/dashboards#index"
  # Admin MLH
    get "/admin/mlh" => "admin/dashboards#mlh_root"
    post "/admin/mlh/sanction/:hackathon_id" => "admin/dashboards#mlh_sanction"
    post "/admin/mlh/unsanction/:hackathon_id" => "admin/dashboards#mlh_unsanction"

  # Subdomain routing
    #get '/' => 'hackathons#show', :constraints => { :sub domain => /.+/ }
    #constraints(Subdomain) do
      #get '/' => 'hackathons#show'
    #end

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
