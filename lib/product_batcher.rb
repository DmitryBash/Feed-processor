# frozen_string_literal: true

require 'oj'

# This class batches products into JSON arrays and sends them to an external service,
# ensuring the JSON batch remains under the 5 MB limit.
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
    product_json = Oj.dump(product.to_h, mode: :compat)
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
    batch_json = Oj.dump(@current_batch, mode: :compat)
    @service.call(batch_json)
    reset_batch
  end

  def reset_batch
    @current_batch = []
    @current_batch_size = JSON_ARRAY_OVERHEAD_BYTES
  end
end
