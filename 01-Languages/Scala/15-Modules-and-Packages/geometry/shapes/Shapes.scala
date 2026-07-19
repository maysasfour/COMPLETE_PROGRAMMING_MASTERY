package geometry.shapes // nested package, matches directory structure geometry/shapes/

case class Circle(radius: Double):
  def area: Double = math.Pi * radius * radius

case class Rectangle(width: Double, height: Double):
  def area: Double = width * height
