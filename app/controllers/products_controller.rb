require_relative './base_controller.rb'

class ProductsController < BaseController
  # GET /products
  def index

    products = [
      { id: 1, name: "Product 1", price: 10.99 },
      { id: 2, name: "Product 2", price: 20.99 },
    ]
    build_response(products)
  end

  # GET /products/:id
  def show
    build_response product_response("this should be one product ##{params[:id]}")
  end

  # POST /products
  def create
    build_response product_response("a response saying that the product is being created")
  end

  # GET /product/new
  def new
    redirect_to "/products"
  end

  private

  def product_response(message)
  end
end
