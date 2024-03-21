# frozen_string_literal: true

require 'bigdecimal'

class Checkout
  attr_reader :products

  def initialize
    @products = {}
    @pricing_rules = {
      'GR1' => ->(quantity, price) { (quantity / 2 * price) + (quantity % 2 * price) },
      'SR1' => ->(quantity, price) { quantity >= 3 ? quantity * BigDecimal('4.50') : quantity * price },
      'CF1' => lambda { |quantity, price|
                 quantity >= 3 ? quantity * price * BigDecimal('2') / BigDecimal('3') : quantity * price
               }
    }
  end

  def scan(product)
    @products[product.code] ||= { quantity: 0, price: product.price }
    @products[product.code][:quantity] += 1
  end

  def total
    total_price = BigDecimal('0')

    @products.each do |_code, data|
      total_price += data[:quantity] * data[:price]
    end

    total_price.round(2)
  end

  def total_with_discount
    total_price = total
    total_price -= total_discount
    total_price.round(2)
  end

  def total_discount
    total_discount = BigDecimal('0')
    @products.each do |code, data|
      pricing_rule = @pricing_rules[code]
      next unless pricing_rule

      original_price = data[:quantity] * data[:price]
      discounted_price = pricing_rule.call(data[:quantity], data[:price])
      total_discount += original_price - discounted_price
    end
    total_discount.round(2)
  end
end
