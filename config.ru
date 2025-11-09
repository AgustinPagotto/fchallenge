require_relative "app"
require "dotenv/load"

use Rack::Reloader, 0
run App.new
