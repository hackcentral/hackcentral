class HC < Grape::API
  format :json

  mount Alpha::Root
  # error_formatter :json, API::ErrorFormatter
  # mount API::V2::Root (next version)

end