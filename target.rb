objects = []

100_000.times do
  objects << Object.new
end
GC.start
GC.start

child_pid = fork do
  gets
end
puts child_pid
STDOUT.flush
Process.waitpid(child_pid)
