require 'rack' 
require 'json'
require 'rack/test'
require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file("config.ru")

RSpec.describe "API TEST" do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  before do
    Product.class_variable_set(:@@products, [])
    Product.class_variable_set(:@@next_id, 1)
  end

  def auth_token
    post "/auth", 
         JSON.generate('username' => "admin", 'password'=> 'secret123'),
         { "CONTENT_TYPE" => "application/json" }

    token = JSON.parse(last_response.body)["token"]
  end

  def add_product(token)
    post "/products", 
         JSON.generate('name'=> 'laptop'),
         { "CONTENT_TYPE" => "application/json",
           "HTTP_AUTHORIZATION" => "Bearer #{token}",
         }
  end

  it "returns 401 when post on /auth with invalid authorization" do
    post("/auth", JSON.generate('username' => 'admin', 'password' => 'secret12'), 'CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq 401
  end

  it "returns 200 when post on /auth with valid authorization" do
    post("/auth", JSON.generate('username' => 'admin', 'password' => 'secret123'), 'CONTENT_TYPE' => 'application/json')
    
    expect(last_response.status).to eq 200

    expect(JSON.parse(last_response.body)["token"]).to be_a(String)
  end

  it "returns 400 when post on /auth with empty username" do
    post("/auth", JSON.generate('username' => 'admin'), 'CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq 400
  end

  it "returns 400 when post on /auth with empty password" do
    post("/auth", JSON.generate('password' => 'secret123'), 'CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq 400
  end

  it "returns 401 when get on /products without authorization" do
    get "/products"

    expect(last_response.status).to eq 401
  end

  it "returns 401 when post on /products without authorization" do
    post("/products", JSON.generate('name' => 'foo'), 'CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq 401
  end

  it "returns 200 with a product when correctly added to the memory and waiting more than 5 seconds" do
    token = auth_token
    add_product(token)
    sleep 5.5
    get "/products", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }

    expect(last_response.status).to eq 200

    json = JSON.parse(last_response.body)
    expect(json[0]["name"]).to eq("laptop")
    expect(JSON.parse(last_response.body)[0]["name"]).to eq("laptop")
  end

  it "returns 200 with no product when correctly added to the memory and not waiting more than 5 seconds" do
    token = auth_token
    add_product(token)
    get "/products", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }

    expect(last_response.status).to eq 200
    expect(JSON.parse(last_response.body)).to be_empty
  end

  it "returns 201 when creating a new product with name and authorization" do
    token = auth_token
    post "/products", 
         JSON.generate('name'=> 'laptop'),
         { "CONTENT_TYPE" => "application/json",
           "HTTP_AUTHORIZATION" => "Bearer #{token}",
         }

    expect(last_response.status).to eq 201
  end
end
