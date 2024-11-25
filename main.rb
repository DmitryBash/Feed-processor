require_relative 'lib/product_feed_processor'

file_path = 'feed.xml'
ProductFeedProcessor.new(file_path).run
