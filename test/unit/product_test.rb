require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new #empty product
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  def setup_product
    product = Product.new(:title => 'El Alquimista',
                          :description => 'sobre un nino y sus aventuras',
                          :image_url => 'rails.png') # non-empty one this time
  end

  test 'product price can not be negative' do
    product = setup_product
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
                 product.errors[:price] # comparing messages
  end

  test 'product price can not be zero' do
    product = setup_product
    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
                 product.errors[:price]
  end

  test 'product price must be positive' do
    product = setup_product
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(:title => 'The Bichon Frise',
                :description => 'All about the furry delightful critters known as Bichons',
                :price => 1,
                :image_url => image_url)
  end

  test 'image url' do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif } # sample acceptable ones
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test 'product invalid without unique title' do
    product = Product.new(:title => products(:ruby).title,
                          :description => 'an awesome ruby book',
                          :price => 1,
                          :image_url => 'rails.png')
    #assert product.invalid?
    #assert_equal ['has already been taken'], product.errors[:title]
  end
end
