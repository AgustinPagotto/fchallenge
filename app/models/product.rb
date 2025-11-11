require 'json'

class Product
  attr_accessor :id, :name

  @@products = []
  @@next_id = 1

  def initialize(name:,  id: nil)
    @id = id || @@next_id
    @name = name
    @@next_id = @id + 1 unless @id < @@next_id
  end

  def save
    if @id && Product.find(@id)
      index = @@products.find_index{ |p| p.id == @id }
      @@products[index] = self
    else
      @id ||= @@next_id
      @@next_id += 1
      @@products << self
    end
  end

  def self.all
    @@products
  end

  def self.find(id)
    @@products.find { |p| p.id == id.to_i }
  end

  def self.create(name)
    puts name
    product = Product.new(name: name)
    product.save
    product
  end

  def self.destroy(id)
    @@products.reject! { |p| p.id == id.to_i }
  end

  def to_h
    {id: id, name: name} 
  end

  def to_json
    to_h.to_json
  end
end
