require_relative './base_controller.rb'

class AuthController < BaseController
  def login
    build_response auth_response("this should be a list of products")
  end

  private

  def auth_response
  end
end
