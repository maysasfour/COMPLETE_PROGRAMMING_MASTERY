require "minitest/autorun"
require_relative "../lib/task_repository"

class TaskRepositoryTest < Minitest::Test
  def setup
    @repo = TaskRepository.new(":memory:") # a fresh in-memory DB per test -- full isolation
  end

  def teardown
    @repo.close
  end

  def test_add_returns_task_with_generated_id
    task = @repo.add("Buy milk")
    assert_equal "Buy milk", task.title
    refute task.done?
    assert_kind_of Integer, task.id
  end

  def test_add_rejects_empty_title
    assert_raises(ArgumentError) { @repo.add("") }
    assert_raises(ArgumentError) { @repo.add("   ") }
  end

  def test_all_returns_tasks_in_insertion_order
    @repo.add("First")
    @repo.add("Second")
    titles = @repo.all.map(&:title)
    assert_equal ["First", "Second"], titles
  end

  def test_find_returns_the_matching_task
    added = @repo.add("Find me")
    found = @repo.find(added.id)
    assert_equal added.id, found.id
    assert_equal "Find me", found.title
  end

  def test_find_raises_for_missing_id
    assert_raises(TaskNotFoundError) { @repo.find(9999) }
  end

  def test_complete_marks_task_done
    task = @repo.add("Finish course")
    refute task.done?
    completed = @repo.complete(task.id)
    assert completed.done?
  end

  def test_complete_raises_for_missing_id
    assert_raises(TaskNotFoundError) { @repo.complete(9999) }
  end

  def test_delete_removes_the_task
    task = @repo.add("Temporary")
    @repo.delete(task.id)
    assert_raises(TaskNotFoundError) { @repo.find(task.id) }
  end

  def test_delete_raises_for_missing_id
    assert_raises(TaskNotFoundError) { @repo.delete(9999) }
  end

  def test_stats_reports_correct_counts
    a = @repo.add("A")
    @repo.add("B")
    @repo.complete(a.id)
    stats = @repo.stats
    assert_equal 2, stats[:total]
    assert_equal 1, stats[:done]
    assert_equal 1, stats[:pending]
  end
end
