require_relative "config/routes"
require_relative "app"

use Rack::Deflater
use Rack::Reloader, 0
run App.new
