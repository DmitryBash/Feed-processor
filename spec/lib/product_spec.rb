# frozen_string_literal: true

RSpec.describe Product do
  let(:product) { described_class.new('123', 'Test Product', 'A description') }

  describe '#to_h' do
    it 'returns a hash representation of the product' do
      expect(product.to_h).to eq({ id: '123', title: 'Test Product', description: 'A description' })
    end
  end
end
