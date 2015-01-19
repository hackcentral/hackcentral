class SubdomainPresent
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www' && request.subdomain != 'developers'
  end
end

class SubdomainBlank
  def self.matches?(request)
    request.subdomain.blank? or request.subdomain == 'www' or request.subdomain == 'developers'
  end
end

Rails.application.routes.draw do

  # Subdomain Routing
  constraints(SubdomainPresent) do
    get '/' => 'hackathons#show', as: :hackathon #, :constraints => { :subdomain => /.+/ } #get '/' => 'hackathons#index'#, via: :get#, :constraints => { :subdomain => /.+/ }, via: :get
    get '/participants' => 'hackathon_extras#participants', as: :hackathon_participants
    get '/rules' => 'hackathon_extras#rules', as: :hackathon_rules
  end

  # Normal Routing
  constraints(SubdomainBlank) do
    # Root
      root to: 'pages#home'

    # Static Pages
      get 'pages/about' => "pages#about"
      get 'pages/contact' => "pages#contact"

    # Scaffolds
      resources :profiles
      resources :applications
      resources :submissions, only: :show do
        resource :like, module: :submissions
      end
      resources :hackathons, only: [:index, :show, :new, :create] do
        resources :submissions, except: [:show, :tag]
      end

    # Submission Tags
      get 'tags/:tag', to: 'submissions#tag', as: :tag

    # Devise
      devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'register'}
      resources :users, only: [:show]

    # API
      use_doorkeeper do
        controllers :applications => 'oauth/applications'
      end

      namespace :api, defaults: {format: 'json'} do
        namespace :v1 do
          # APPLICATIONS
            get "applications" => "applications#index"
            post "applications" => "applications#create"
            get "applications/:id" => "applications#show"
            put "applications/:id" => "applications#update"
            patch "applications/:id" => "applications#update"
            delete "applications/:id" => "applications#destroy"

          # HACKATHONS
            get "hackathons" => "hackathons#index"
            post "hackathons" => "hackathons#create"
            get "hackathons/:id" => "hackathons#show"
            put "hackathons/:id" => "hackathons#update"
            patch "hackathons/:id" => "hackathons#update"
            delete "hackathons/:id" => "hackathons#destroy"

          # HACKATHONS --> SUBMISSIONS
            get "hackathons/:hackathon_id/submissions" => "submissions#index"
            post "hackathons/:hackathon_id/submissions" => "submissions#create"
            put "hackathons/:hackathon_id/submissions/:submission_id" => "submissions#update"
            patch "hackathons/:hackathon_id/submissions/:submission_id" => "submissions#update"
            delete "hackathons/:hackathon_id/submissions/:submission_id" => "submissions#destroy"

          # PROFILES
            get "/profiles" => "profiles#index"
            post "profiles" => "profiles#create"
            get "profiles/:id" => "profiles#show"
            put "profiles/:id" => "profiles#update"
            patch "profiles/:id" => "profiles#update"
            delete "profiles/:id" => "profiles#destroy"

          # SUBMISSIONS
            get "submissions/:submission_id" => "submissions#show"

          # TAGS
            get 'tags/:tag', to: 'submissions#tag', as: :tag

          # USER
            get '/user' => "users#show"
        end
      end

    namespace :admin do
      # Root Admin
        get '', to: 'dashboards#index', as: '/'
      # MLH Admin
        get "/mlh" => "dashboards#mlh_root"
        post "/mlh/sanction/:id" => "dashboards#mlh_sanction"
        post "/mlh/unsanction/:id" => "dashboards#mlh_unsanction"
      # Organizer Admin
        get "/hackathons/:id" => "hackathons#index", as: :hackathon

        get "/hackathons/:id/applications" => "hackathons#application_index", as: :hackathon_applications
        get "/hackathons/:id/applications/:application_id/" => "hackathons#application_show", as: :hackathon_application
        post "/hackathons/:id/applications/:application_id/accept" => "hackathons#application_accept"
        post "/hackathons/:id/applications/:application_id/unaccept" => "hackathons#application_unaccept"

        get "/hackathons/:id/tickets" => "hackathons#checkin_index", as: :hackathon_tickets
        post "/hackathons/:id/:application_id/checkin" => "hackathons#checkin"
        post "/hackathons/:id/:application_id/uncheckin" => "hackathons#uncheckin"


        resources :hackathons, only: [:edit, :update, :destroy], controller: 'hackathons' do
          resources :organizers, only: [:index, :new, :create, :destroy]
        end
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