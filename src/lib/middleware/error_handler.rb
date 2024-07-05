module Middleware
  class ErrorHandler
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        # @request = ActionDispatch::Request.new(env)
        @app.call(env)
      rescue ServerError => e
        render(e)
      rescue ActiveRecord::ActiveRecordError => e
        raise ServerError::NotFound.wrap(e)
      rescue ActionController::BadRequest => e
        raise ServerError::BadRequest.wrap(e)
      rescue StandardError => e
        raise ServerError::InternalServerError.wrap(e)
      end
    rescue ServerError => e
      render(e)
    end

    private

    def render(e)
      body = { code: e.code }

      unless Rails.env.production?
        body.merge!(
          {
            debug: {
              error: e.class.name,
              detail: e.message,
              backtrace: Rails.backtrace_cleaner.clean(e.backtrace)
            }
          }
        )
      end

      [e.status, headers, [body.to_json]]
    end

    def headers
      {
        "Content-Type" => "application/problem+json"
      }
    end
  end
end
