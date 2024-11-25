class Product
  attr_reader :id, :title, :description

  def initialize(id, title, description)
    @id = id
    @title = title
    @description = description
  end

  def to_h
    { id: @id, title: @title, description: @description }
  end
end
