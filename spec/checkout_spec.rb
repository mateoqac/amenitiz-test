# frozen_string_literal: true

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
end
