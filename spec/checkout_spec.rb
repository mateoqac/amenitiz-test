# frozen_string_literal: true

require './models/checkout'
require './models/product'

RSpec.describe 'Checkout' do
  let(:checkout) { Checkout.new }
  before do
    @products = {
      'GR1' => Product.new('GR1', 'Green Tea', '3.11'),
      'SR1' => Product.new('SR1', 'Strawberries', '5.00'),
      'CF1' => Product.new('CF1', 'Coffee', '11.23')
    }
  end

  it 'computes total price correctly for test data 1' do
    checkout.scan(@products['GR1'])
    checkout.scan(@products['GR1'])
    expect(checkout.total_with_discount).to eq(BigDecimal('3.11'))
  end

  it 'computes total price correctly for test data 2' do
    checkout.scan(@products['SR1'])
    checkout.scan(@products['SR1'])
    checkout.scan(@products['GR1'])
    checkout.scan(@products['SR1'])
    expect(checkout.total_with_discount).to eq(BigDecimal('16.61'))
  end

  it 'computes total price correctly for test data 3' do
    checkout.scan(@products['GR1'])
    checkout.scan(@products['CF1'])
    checkout.scan(@products['SR1'])
    checkout.scan(@products['CF1'])
    checkout.scan(@products['CF1'])
    expect(checkout.total_with_discount).to eq(BigDecimal('30.57'))
  end

  describe '#scan' do
    context 'when scanning a new product' do
      it 'adds the product to the list of scanned items' do
        checkout.scan(Product.new('GR1', 'Green Tea', BigDecimal('3.11')))
        expect(checkout.products).to include('GR1' => { quantity: 1,
                                                        price: BigDecimal('3.11') })
      end
    end

    context 'when scanning an existing product' do
      it 'increments the quantity of the scanned product' do
        checkout.scan(Product.new('SR1', 'Strawberries', BigDecimal('5.00')))
        checkout.scan(Product.new('SR1', 'Strawberries', BigDecimal('5.00')))
        expect(checkout.products['SR1'][:quantity]).to eq(2)
      end
    end
  end

  describe '#total' do
    context 'when there are no items scanned' do
      it 'returns total price of 0' do
        expect(checkout.total).to eq(BigDecimal('0'))
      end
    end

    context 'when only one type of item is scanned' do
      it 'returns total price without discount' do
        checkout.scan(Product.new('SR1', 'Strawberries', BigDecimal('5.00')))
        checkout.scan(Product.new('SR1', 'Strawberries', BigDecimal('5.00')))
        expect(checkout.total).to eq(BigDecimal('10.00'))
      end
    end

    context 'when multiple types of items are scanned' do
      it 'returns total price with discounts applied' do
        checkout.scan(Product.new('GR1', 'Green Tea', BigDecimal('3.11')))
        checkout.scan(Product.new('SR1', 'Strawberries', BigDecimal('5.00')))
        checkout.scan(Product.new('CF1', 'Coffee', BigDecimal('11.23')))
        checkout.scan(Product.new('CF1', 'Coffee', BigDecimal('11.23')))
        expect(checkout.total).to eq(BigDecimal('30.57'))
      end
    end
  end

  describe '#total_discount' do
    context 'when product has an entry in pricing_rules' do
      it 'calculates total discount' do
        checkout.scan(Product.new('GR1', 'Green Tea', BigDecimal('3.11')))
        checkout.scan(Product.new('GR1', 'Green Tea', BigDecimal('3.11')))
        expect(checkout.total_discount).to eq(BigDecimal('3.11'))
      end
    end

    context 'when product does not have an entry in pricing_rules' do
      it 'does not calculate discount for the product' do
        checkout.scan(Product.new('PZ1', 'Pizza', BigDecimal('7.00')))
        checkout.scan(Product.new('PZ1', 'Pizza', BigDecimal('7.00')))
        expect(checkout.total_discount).to eq(BigDecimal('0'))
      end
    end
  end

  describe '#total_with_discount' do
    context 'when no items are scanned' do
      it 'returns total price of 0' do
        expect(checkout.total_with_discount).to eq(BigDecimal('0'))
      end
    end

    context 'when only one type of item with pricing rule is scanned' do
      it 'returns total price after applying discount' do
        checkout.scan(Product.new('GR1', 'Green Tea', BigDecimal('3.11')))
        checkout.scan(Product.new('GR1', 'Green Tea', BigDecimal('3.11')))
        expect(checkout.total_with_discount).to eq(BigDecimal('3.11'))
      end
    end

    context 'when multiple types of items with pricing rules are scanned' do
      it 'returns total price after applying discount' do
        checkout.scan(Product.new('GR1', 'Green Tea', BigDecimal('3.11')))
        checkout.scan(Product.new('SR1', 'Strawberries', BigDecimal('5.00')))
        checkout.scan(Product.new('CF1', 'Coffee', BigDecimal('11.23')))
        checkout.scan(Product.new('CF1', 'Coffee', BigDecimal('11.23')))
        checkout.scan(Product.new('CF1', 'Coffee', BigDecimal('11.23')))
        expect(checkout.total_with_discount).to eq(BigDecimal('30.57'))
      end
    end
  end
end
