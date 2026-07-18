# A plain value object representing one task row. Kept deliberately dumb --
# all persistence logic lives in TaskRepository, not here.
class Task
  attr_reader :id, :title, :done
  alias_method :done?, :done   # predicate-style reader, per Lesson 19's naming convention

  def initialize(id:, title:, done:)
    @id = id
    @title = title
    @done = done
  end

  def to_s
    marker = done? ? "x" : " "
    "[#{marker}] ##{id} #{title}"
  end
end
