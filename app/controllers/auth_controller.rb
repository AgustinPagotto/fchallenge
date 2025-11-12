require_relative './base_controller'
require 'securerandom'

class AuthController < BaseController
  @@tokens = []

  def index
    puts params
  end

  def create
    body = request.body.read
    data = JSON.parse(body)
    username = data["username"]
    password = data["password"]
    if username.nil? || username.strip.empty? || password.nil? || password.strip.empty?
      return build_response({error: "Username and Password are requires"}, 400)
    end
    if ENV["USERNAME"] == username && ENV["PASSWORD"] == password
      token = SecureRandom.hex(32)
      @@tokens << token
      build_response({ token: token })
    else
      build_response({ error: "Invalid credentials" }, 401)
    end
  end

  def self.valid_token?(token)
    @@tokens.include?(token)
  end

  def self.clear_tokens!
    @@tokens = []
  end
end
