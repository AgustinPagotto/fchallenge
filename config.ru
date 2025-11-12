require_relative "app"
require_relative "middleware/auth_middleware"
require "dotenv/load"

use Rack::Reloader, 0
use Rack::Deflater
use AuthChecker
run App.new
