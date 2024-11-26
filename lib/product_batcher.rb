# frozen_string_literal: true

require 'json'
# This class is responsible for batching products into JSON arrays and sending them to an external service.
# To ensure the JSON batch remains under the 5 MB limit, we account for the following:
# - JSON_ARRAY_OVERHEAD_BYTES: Represents the size of the opening `[` and closing `]` brackets in a JSON array.
# - JSON_COMMA_OVERHEAD_BYTES: Represents the size of a comma (`,`) that separates items in a JSON array.
# These values are essential for accurately calculating the size of the JSON payload while adding new products
# to the batch. Without these adjustments, the payload size might exceed the specified limit, causing errors.

class ProductBatcher
  MAX_BATCH_SIZE_BYTES = 5 * 1_048_576 # 5 MB
  JSON_ARRAY_OVERHEAD_BYTES = 2
  JSON_COMMA_OVERHEAD_BYTES = 1

  def initialize(service)
    @service = service
    @current_batch = []
    @current_batch_size = JSON_ARRAY_OVERHEAD_BYTES
  end

  def add(product)
    product_json = JSON.dump(product.to_h)
    product_size = product_json.bytesize + (@current_batch.empty? ? 0 : JSON_COMMA_OVERHEAD_BYTES)

    process_batch if (@current_batch_size + product_size) > MAX_BATCH_SIZE_BYTES

    @current_batch << product.to_h
    @current_batch_size += product_size
  end

  def finalize
    process_batch unless @current_batch.empty?
  end

  private

  def process_batch
    batch_json = JSON.dump(@current_batch)
    @service.call(batch_json)
    reset_batch
  end

  def reset_batch
    @current_batch = []
    @current_batch_size = JSON_ARRAY_OVERHEAD_BYTES
  end
end
