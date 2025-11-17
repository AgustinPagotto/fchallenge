require 'spec_helper'
require_relative '../app/models/product.rb'

RSpec.describe Product do
  before(:each) do
    Product.class_variable_set(:@@products, [])
    Product.class_variable_set(:@@next_id, 1)
  end

  describe '#initialize' do
    it 'creates a product' do
      product = Product.new(name: 'Laptop')

      expect(product.name).to eq('Laptop')
    end

    it 'creates a product with custom id' do
      product = Product.new(name: 'Mouse', id: 5)

      expect(product.id).to eq(5)
    end
  end

  describe '#save' do
    it 'saves a new product' do
      product = Product.new(name: 'Laptop')
      product.save

      expect(Product.all).to include(product)
      expect(Product.all.size).to eq(1)
    end
    it 'increments id for each new product' do
      product1 = Product.new(name: 'Product 1')
      product1.save

      product2 = Product.new(name: 'Product 2')
      product2.save

      expect(product1.id).to eq(1)
      expect(product2.id).to eq(2)
    end
  end

  describe '.all' do
    it 'returns empty array when no products' do
      expect(Product.all).to eq([])
    end
    it 'returns all products' do
      product1 = Product.create(name: 'Laptop')
      product2 = Product.create(name: 'Mouse')

      expect(Product.all.size).to eq(2)
      expect(Product.all).to include(product1, product2)
    end
  end

  describe '.find' do
    it 'finds a product by id' do
      product = Product.create(name: 'Laptop')

      found = Product.find(product.id)
      expect(found).to eq(product)
    end

    it 'returns nil when product not found' do
      expect(Product.find(999)).to be_nil
    end

    it 'finds product by string id' do
      product = Product.create(name: 'Laptop')

      found = Product.find('1')
      expect(found).to eq(product)
    end
  end

  describe '.create' do
    it 'creates and saves a product' do
      product = Product.create(name: 'Laptop', price: 999.99)

      expect(product).to be_a(Product)
      expect(product.id).not_to be_nil
      expect(Product.all).to include(product)
    end

    it 'creates product without price' do
      product = Product.create(name: 'Keyboard')

      expect(Product.all).to include(product)
    end
  end
end
