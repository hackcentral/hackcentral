class HC < Grape::API
  format :json
  use WineBouncer::OAuth2

  mount Alpha::Root

  desc 'This method uses Doorkeepers default scopes.',
    auth: { scopes: [] }
    get '/protected_with_default_scope' do
       { hello: 'protected unscoped world' }
    end

  # error_formatter :json, API::ErrorFormatter
  # mount API::V2::Root (next version)

end