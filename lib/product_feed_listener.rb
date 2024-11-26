# frozen_string_literal: true

require 'rexml/parsers/streamparser'
require 'rexml/streamlistener'

class ProductFeedListener
  include REXML::StreamListener

  def initialize(batcher)
    @batcher = batcher
    @current_element = nil
  end

  def tag_start(name, _attributes)
    case name
    when 'item'
      @current_product = {}
    when 'g:id', 'title', 'description'
      @current_element = name
    end
  end

  def text(data)
    return unless @current_element

    case @current_element
    when 'g:id', 'title', 'description'
      @current_product[@current_element] = data.strip
    end
  end

  def tag_end(name)
    case name
    when 'item'
      process_product(build_product(@current_product))
    when 'g:id', 'title', 'description'
      @current_element = nil
    end
  end

  private

  def build_product(attributes)
    Product.new(
      id: attributes['g:id'],
      title: attributes['title'],
      description: attributes['description']
    )
  end

  def process_product(product)
    @batcher.add(product) if product.valid?
  end
end
