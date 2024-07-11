require 'middleware/error_handler'

Rails.application.configure do
  config.middleware.use Middleware::ErrorHandler
end
