require 'rexml/parsers/streamparser'
require_relative 'product_feed_listener'

class ProductFeedParser
  def initialize(file_path, batcher)
    @file_path = file_path
    @batcher = batcher
  end

  def parse
    File.open(@file_path) do |file|
      listener = ProductFeedListener.new(@batcher)
      REXML::Parsers::StreamParser.new(file, listener).parse
    end

    @batcher.finalize
  end
end
