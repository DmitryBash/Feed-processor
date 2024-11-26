# frozen_string_literal: true

RSpec.describe ProductBatcher do
  let(:service) { instance_double(ExternalService, call: true) }
  let(:batcher) { described_class.new(service) }
  let(:product) { { id: '123', title: 'Test Product', description: 'A description' } }

  describe '#add' do
    it 'processes the batch when size exceeds the limit' do
      allow(service).to receive(:call)
      large_product = { id: '1', title: 'A' * 5_242_880, description: 'Large description' }

      batcher.add(large_product)
      expect(service).to have_received(:call).once
    end
  end

  describe '#finalize' do
    it 'processes the remaining batch' do
      batcher.add(product)
      allow(service).to receive(:call)

      batcher.finalize
      expect(service).to have_received(:call).once
    end
  end
end
