require_relative '../app/controllers/auth_controller'

class AuthChecker
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env["PATH_INFO"]
    if path == "/auth" || path == "/openapi.yaml" || path == "/AUTHORS"
      return @app.call(env)
    end

    auth_header = env["HTTP_AUTHORIZATION"]
    if valid_token?(auth_header)
      @app.call(env)
    else
      [
        401,
        { "Content-Type" => "application/json" },
        [{ error: "Unauthorized" }.to_json]
      ]
    end
  end

  private

  def valid_token?(auth_header)
    return false if auth_header.nil?

    # Style of header: "Bearer secret-token"
    token = auth_header.split(" ").last
    AuthController.valid_token?(token)
  end
end
