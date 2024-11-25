require_relative 'external_service'
require_relative 'product'
require_relative 'product_batcher'
require_relative 'product_feed_parser'

class ProductFeedProcessor
  def initialize(file_path)
    @file_path = file_path
  end

  def run
    service = ExternalService.new
    batcher = ProductBatcher.new(service)
    parser = ProductFeedParser.new(@file_path, batcher)

    parser.parse
  end
end
