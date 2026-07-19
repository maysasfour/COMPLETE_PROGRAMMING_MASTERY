// Domain model: an immutable case class (Lesson 11), the idiomatic representation
// of a plain data record.
case class Task(id: Int, description: String, done: Boolean)
