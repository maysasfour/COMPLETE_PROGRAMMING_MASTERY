# Solution 7 -- Capstone: Shape Hierarchy with a Mixin and Duck Typing
module Measurable
  def describe
    "#{self.class.name}: area=#{area.round(2)}, perimeter=#{perimeter.round(2)}"
  end
end

class Circle
  include Measurable
  def initialize(radius)
    @radius = radius
  end

  def area
    Math::PI * @radius**2
  end

  def perimeter
    2 * Math::PI * @radius
  end
end

class Rectangle
  include Measurable
  def initialize(width, height)
    @width, @height = width, height
  end

  def area
    @width * @height
  end

  def perimeter
    2 * (@width + @height)
  end
end

def total_area(shapes)
  shapes.sum(&:area)
end

shapes = [Circle.new(3), Rectangle.new(4, 5), Circle.new(1)]
shapes.each { |s| puts s.describe }
puts "total area: #{total_area(shapes).round(2)}"

puts "Object.new responds_to?(:describe) = #{Object.new.respond_to?(:describe)}"
puts "Circle.new(1) responds_to?(:describe) = #{Circle.new(1).respond_to?(:describe)}"
