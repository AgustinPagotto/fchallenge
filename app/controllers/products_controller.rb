require_relative './base_controller.rb'

class ProductsController < BaseController
  # GET /products
  def index
    products = Product.all.map { |p| p.to_h }
    build_response(products)
  end

  # GET /products/:id
  def show
    product = Product.find(params[:id])
    if product
      build_response(product)
    else
      not_found
    end
  end

  # POST /products
  def create
    async_time = ENV["ASYNC_TIME"].to_i
    body = request.body.read
    data = JSON.parse(body)
    name = data["name"]
    if name.nil? || name.strip.empty?
      return build_response({ error: "name is required" }, 400)
    end
    if name.match(/\d/)
      return build_response({ error: "name can't contain numbers" }, 400)
    end

    Thread.new do
      sleep async_time
      Product.create(data["name"])
    end
    build_response({ message: "the product will be created after 5 seconds" }, 201)
  end

  # GET /product/new
  def new
    redirect_to "/products"
  end
end
