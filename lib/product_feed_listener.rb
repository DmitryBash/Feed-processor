require 'rexml/parsers/streamparser'
require 'rexml/streamlistener'

class ProductFeedListener
  include REXML::StreamListener

  def initialize(batcher)
    @batcher = batcher
    @current_product = {}
    @current_element = nil
  end

  def tag_start(name, _attributes)
    @current_element = name if %w[g:id title description].include?(name)
  end

  def text(data)
    return unless @current_element

    case @current_element
    when 'g:id'
      @current_product[:id] = data.strip
    when 'title'
      @current_product[:title] = data.strip
    when 'description'
      @current_product[:description] = data.strip
    end
  end

  def tag_end(name)
    if name == 'item'
      process_product if valid_product?
      reset_product
    end
  
    @current_element = nil
  end
  
  private
  
  def valid_product?
    @current_product[:id] && @current_product[:title] && @current_product[:description]
  end
  
  def process_product
    @batcher.add(Product.new(@current_product[:id], @current_product[:title], @current_product[:description]))
  end
  
  def reset_product
    @current_product = {}
  end
end
