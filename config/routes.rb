class SubdomainPresent
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www' && request.subdomain != 'developers' && request.subdomain != 'api'
  end
end

class SubdomainBlank
  def self.matches?(request)
    request.subdomain.blank? or request.subdomain == 'www' or request.subdomain == 'developers' or request.subdomain == 'api'
  end
end

Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/superadmin', as: 'rails_admin'
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
      resources :applications do
        member do
          post "rsvp_yes"
          post "rsvp_no"
        end
      end
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
      # DOORKEEPER
        use_doorkeeper do
          controllers :applications => 'oauth/applications'
        end

      namespace 'api', path: "", constraints: {:subdomain => "api"}, defaults: {format: 'json'} do
        mount HC => '/'
      end

      namespace :api, path: "", :constraints => {:subdomain => "api"}, defaults: {format: 'json'} do
        namespace :v1 do

          # HACKATHONS --> SUBMISSIONS
            get "hackathons/:hackathon_id/submissions" => "submissions#index"
            post "hackathons/:hackathon_id/submissions" => "submissions#create"
            put "hackathons/:hackathon_id/submissions/:submission_id" => "submissions#update"
            patch "hackathons/:hackathon_id/submissions/:submission_id" => "submissions#update"
            delete "hackathons/:hackathon_id/submissions/:submission_id" => "submissions#destroy"

          # TAGS
            get 'tags/:tag', to: 'submissions#tag', as: :tag
        end
      end

    namespace :admin do
      # Root Admin
        get '', to: 'dashboards#index', as: '/'
      # MLH Admin
        get "/mlh" => "dashboards#mlh_root"
        post "/mlh/sanction/:hackathon_id" => "dashboards#mlh_sanction"
        post "/mlh/unsanction/:hackathon_id" => "dashboards#mlh_unsanction"
      # Organizer Admin
        get "/hackathons/:hackathon_id" => "hackathons#index", as: :hackathon

        get "/hackathons/:hackathon_id/applications" => "hackathons#application_index", as: :hackathon_applications
        get "/hackathons/:hackathon_id/applications/:application_id/" => "hackathons#application_show", as: :hackathon_application
        post "/hackathons/:hackathon_id/applications/:application_id/accept" => "hackathons#application_accept"
        post "/hackathons/:hackathon_id/applications/:application_id/unaccept" => "hackathons#application_unaccept"

        get "/hackathons/:hackathon_id/tickets" => "hackathons#checkin_index", as: :hackathon_tickets
        post "/hackathons/:hackathon_id/:application_id/checkin" => "hackathons#checkin"
        post "/hackathons/:hackathon_id/:application_id/uncheckin" => "hackathons#uncheckin"

      # Hackathon Admin
        get "/hackathons/:hackathon_id/edit" => "hackathons#edit", as: :edit_hackathon
        put "/hackathons/:hackathon_id/" => "hackathons#update"
        patch "/hackathons/:hackathon_id/" => "hackathons#update"
        delete "/hackathons/:hackathon_id/" => "hackathons#destroy"

      # Hackathon --> Organizer Admin
        get "/hackathons/:hackathon_id/organizers" => "organizers#index", as: :hackathon_organizers
        get "/hackathons/:hackathon_id/organizers/new" => "organizers#new", as: :new_hackathon_organizer
        post "/hackathons/:hackathon_id/organizers" => "organizers#create"
        delete "/hackathons/:hackathon_id/organizers/:id" => "organizers#destroy", as: :hackathon_organizer

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