package geometry // one level up from geometry.shapes

import geometry.shapes.{Circle, Rectangle} // explicit import -- only what's used, into scope

object Formatter:
  def describe(c: Circle): String = f"Circle(r=${c.radius}%.1f) area=${c.area}%.2f"
  def describe(r: Rectangle): String = f"Rectangle(${r.width}%.1fx${r.height}%.1f) area=${r.area}%.2f"
