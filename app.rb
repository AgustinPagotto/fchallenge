app_files = File.expand_path('app/**/*.rb', __dir__)
Dir.glob(app_files).each { |file| require(file) }
require_relative 'config/router'

class App
  def call(env)
    request = Rack::Request.new(env)
    serve_request(request)
  end

  def serve_request(request)
    Router.new(request).route!
  end
end
