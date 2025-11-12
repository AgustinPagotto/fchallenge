require 'rack'
require 'json'
require_relative '../app/controllers/products_controller'
require_relative '../app/models/product'

RSpec.describe ProductsController do
  def build_request(method:, path:, body: nil, params: {})
    env = Rack::MockRequest.env_for(
      path,
      method: method,
      input: body ? body.to_json : nil
    )
    Rack::Request.new(env.merge('rack.request.query_hash' => params))
  end

  before do
    Product.class_variable_set(:@@products, [])
    Product.class_variable_set(:@@next_id, 1)
  end

  describe '#index' do
    it 'returns all products as JSON with status 200' do
      Product.create('Laptop')
      Product.create('Mouse')

      request = build_request(method: 'GET', path: '/products')
      controller = ProductsController.new(request)
      status, headers, body = controller.index

      expect(status).to eq(200)
      expect(headers['Content-Type']).to eq('text/json')

      parsed = JSON.parse(body.first)
      expect(parsed.size).to eq(2)
      expect(parsed.first['name']).to eq('Laptop')
    end
  end

  describe '#show' do
    it 'returns a single product if found' do
      product = Product.create('Laptop')

      request = build_request(method: 'GET', path: "/products/#{product.id}", params: { 'id' => product.id })
      controller = ProductsController.new(request)
      status, _headers, body = controller.show

      parsed = JSON.parse(body.first)
      expect(status).to eq(200)
      expect(parsed['name']).to eq('Laptop')
    end

    it 'returns 404 if product not found' do
      request = build_request(method: 'GET', path: '/products/99', params: { 'id' => 99 })
      controller = ProductsController.new(request)
      status, _headers, body = controller.show

      parsed = JSON.parse(body.first)
      expect(status).to eq(404)
      expect(parsed['error']).to eq('not found')
    end
  end

  describe '#create' do
    it 'creates a product asynchronously and returns 201' do
      # prevent thread delay for testing
      allow(Thread).to receive(:new).and_yield

      request = build_request(method: 'POST', path: '/products', body: { name: 'Coffee' })
      controller = ProductsController.new(request)

      status, _headers, body = controller.create
      parsed = JSON.parse(body.first)

      expect(status).to eq(201)
      expect(parsed['message']).to include('5 seconds')
      expect(Product.all.first.name).to eq('Coffee')
    end

    it 'returns 400 if name is missing' do
      request = build_request(method: 'POST', path: '/products', body: {})
      controller = ProductsController.new(request)

      status, _headers, body = controller.create
      parsed = JSON.parse(body.first)

      expect(status).to eq(400)
      expect(parsed['error']).to eq('name is required')
    end

    it "returns 400 if name contains numbers" do
      request = build_request(method: 'POST', path: '/products', body: { name: 'Item123' })
      controller = ProductsController.new(request)

      status, _headers, body = controller.create
      parsed = JSON.parse(body.first)

      expect(status).to eq(400)
      expect(parsed['error']).to include("numbers")
    end
  end
end
