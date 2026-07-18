#!/usr/bin/env ruby
# CLI Task Tracker -- Ruby course capstone mini-project.
# Usage:
#   ruby cli.rb add "Buy milk"
#   ruby cli.rb list
#   ruby cli.rb done 2
#   ruby cli.rb delete 3
#   ruby cli.rb stats
require_relative "lib/task_repository"

DB_PATH = File.join(__dir__, "tasks.db")

def usage
  puts "Usage: ruby cli.rb <add|list|done|delete|stats> [args]"
end

command = ARGV[0]
repo = TaskRepository.new(DB_PATH)

begin
  case command
  when "add"
    title = ARGV[1..].join(" ")
    task = repo.add(title)
    puts "Added: #{task}"
  when "list"
    tasks = repo.all
    if tasks.empty?
      puts "No tasks yet."
    else
      tasks.each { |t| puts t }
    end
  when "done"
    id = Integer(ARGV[1])
    task = repo.complete(id)
    puts "Completed: #{task}"
  when "delete"
    id = Integer(ARGV[1])
    repo.delete(id)
    puts "Deleted task ##{id}"
  when "stats"
    s = repo.stats
    puts "Total: #{s[:total]}  Done: #{s[:done]}  Pending: #{s[:pending]}"
  else
    usage
  end
rescue TaskNotFoundError => e
  puts "Error: #{e.message}"
rescue ArgumentError => e
  puts "Error: #{e.message}"
ensure
  repo.close
end
