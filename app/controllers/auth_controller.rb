require_relative './base_controller.rb'

class AuthController < BaseController
  def index 
    build_response("this should be a login")
  end
end
