# Subclasses StandardError (not Exception) per Lesson 09, so a bare `rescue`
# in calling code actually catches it.
class TaskNotFoundError < StandardError
  def initialize(id)
    super("no task found with id #{id}")
  end
end
