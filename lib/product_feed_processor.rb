# frozen_string_literal: true

require_relative 'external_service'
require_relative 'product'
require_relative 'product_batcher'
require_relative 'product_feed_parser'

class ProductFeedProcessor
  class EmptyFileError < StandardError; end

  def initialize(file_path)
    @file_path = file_path
  end

  def run
    validate_file!
    process_feed
  rescue Errno::ENOENT
    handle_file_not_found
  rescue REXML::ParseException => e
    handle_invalid_xml(e)
  rescue EmptyFileError
    handle_empty_file
  end

  private

  def validate_file!
    raise Errno::ENOENT unless File.exist?(@file_path)
    raise EmptyFileError if File.empty?(@file_path)
  end

  def process_feed
    service = ExternalService.new
    batcher = ProductBatcher.new(service)

    ProductFeedParser.new(@file_path, batcher).parse
  end

  def handle_file_not_found
    puts "Error: File not found - #{@file_path}"
  end

  def handle_invalid_xml(exception)
    puts "Error: Invalid XML format - #{exception.message}"
  end

  def handle_empty_file
    puts 'Error: The XML file is empty.'
  end
end
