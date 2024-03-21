# frozen_string_literal: true

require './models/product'
require './models/checkout'

module Main
  PRODUCTS = {
    'GR1' => Product.new('GR1', 'Green Tea', '3.11'),
    'SR1' => Product.new('SR1', 'Strawberries', '5.00'),
    'CF1' => Product.new('CF1', 'Coffee', '11.23')
  }.freeze

  def self.display_products
    puts 'Available products:'
    PRODUCTS.each { |code, product| puts "#{code}: #{product.name} - #{product.price.to_f} €" }
  end

  def self.scan_product(checkout, input)
    if PRODUCTS.key?(input)
      product = PRODUCTS[input]
      checkout.scan(product)
      puts "Scanned: #{product.name}"
    else
      puts 'Invalid product code. Please try again.'
    end
  end

  def self.display_scanned_items(checkout)
    puts '-------------------------------------------'
    puts 'Scanned Items:'
    checkout.instance_variable_get(:@products).each do |code, data|
      product = PRODUCTS[code]
      puts "#{data[:quantity]} x #{product.name} - #{data[:quantity] * product.price.to_f} €"
    end
  end

  def self.display_total_price(checkout)
    puts '-------------------------------------------'
    current_total = checkout.instance_variable_get(:@products).sum do |code, data|
      product = PRODUCTS[code]
      data[:quantity] * product.price
    end
    puts "Total price before discounts: #{current_total.to_f} €"
  end

  def self.display_discounts(checkout)
    total_discount = checkout.total_discount
    puts "Discount applied: #{total_discount.to_f} €" if total_discount > BigDecimal('0')
  end

  def self.display_total_price_after_discounts(checkout)
    total_after_discounts = checkout.total_with_discount
    puts "Total price after discounts: #{total_after_discounts.to_f} €"
  end

  def self.run
    checkout = Checkout.new

    loop do
      display_products

      print "Scan product (or 'done' to finish): "
      input = gets.chomp.upcase

      break if input == 'DONE'

      scan_product(checkout, input)
    end

    display_scanned_items(checkout)
    display_total_price(checkout)
    display_discounts(checkout)
    display_total_price_after_discounts(checkout)
  end
end

Main.run if __FILE__ == $PROGRAM_NAME
