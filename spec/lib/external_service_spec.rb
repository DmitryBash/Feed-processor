# frozen_string_literal: true

RSpec.describe ExternalService do
  let(:service) { described_class.new }
  let(:batch) { JSON.dump([{ id: '1', title: 'Product 1', description: 'Description 1' }]) }

  describe '#call' do
    it 'prints the batch details' do
      expect { service.call(batch) }.to output(/Received batch/).to_stdout
    end
  end
end
