require_relative './base_controller.rb'

class ProductsController < BaseController
  # GET /products
  def index
    products = Product.all.map{|p| p.to_h}
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
    product = Product.create(params[:name])
    build_response(product.to_h, 201)
  end

  # GET /product/new
  def new
    redirect_to "/products"
  end

end
