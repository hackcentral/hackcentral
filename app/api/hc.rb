class HC < Grape::API
  format :json
  use ::WineBouncer::OAuth2

  mount Alpha::Root
  # error_formatter :json, API::ErrorFormatter
  # mount API::V2::Root (next version)

end