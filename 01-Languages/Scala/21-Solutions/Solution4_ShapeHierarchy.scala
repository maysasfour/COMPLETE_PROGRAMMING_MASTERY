// Solution 4 -- shape hierarchy with traits (Lesson 11)

trait Shape:
  def area: Double
  def describe: String = f"${this.getClass.getSimpleName} with area $area%.2f" // concrete default method

case class Circle(radius: Double) extends Shape:
  def area: Double = math.Pi * radius * radius

case class Square(side: Double) extends Shape:
  def area: Double = side * side

def totalArea(shapes: List[Shape]): Double = shapes.map(_.area).sum

@main def solution4ShapeHierarchy(): Unit =
  val shapes: List[Shape] = List(Circle(2.0), Square(3.0), Circle(1.0))
  shapes.foreach(s => println(s.describe))
  println(f"total area = ${totalArea(shapes)}%.2f")
