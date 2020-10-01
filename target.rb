# frozen_string_literal: true

objects = []

1_000_000.times do
  objects << String.new
end
objects.each { |s| s << "a" }

GC.start
GC.start

child_pid = fork do
  STDOUT.puts Process.pid
  STDOUT.flush
  gets

  GC.start

  STDOUT.puts "ok"
  STDOUT.flush
  gets
end
Process.waitpid(child_pid)
