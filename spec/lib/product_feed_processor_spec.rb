# frozen_string_literal: true

RSpec.describe ProductFeedProcessor do
  let(:file_path) { 'spec/fixtures/feed.xml' }
  let(:processor) { described_class.new(file_path) }

  describe '#run' do
    context 'when file is missing' do
      let(:file_path) { 'nonexistent.xml' }

      it 'prints a file not found error' do
        expect { processor.run }.to output(/Error: File not found/).to_stdout
      end
    end

    context 'when file is empty' do
      let(:file_path) { 'spec/fixtures/empty.xml' }

      it 'prints a file empty error' do
        File.write(file_path, '')
        expect { processor.run }.to output(/Error: The XML file is empty/).to_stdout
      end
    end
  end
end
