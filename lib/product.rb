# frozen_string_literal: true

class Product
  def initialize(id: nil, title: nil, description: nil)
    @id = id
    @title = title
    @description = description
  end

  def to_h
    { id: @id, title: @title, description: @description }
  end

  def valid?
    @id && @title && @description
  end
end
