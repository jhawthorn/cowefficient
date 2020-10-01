require "open3"

RUBY_PATH = RbConfig.ruby

MAPPING = /^(Shared|Private).*:\s+(\d+)/

def summarize_smap(pid)
  data = File.read("/proc/#{pid}/smaps")
  total = Hash.new(0)
  data.scan(MAPPING) do |type, n|
    total[type] += n.to_i
  end
  pp total
end

def run
  cmd = [RUBY_PATH, "--disable-gems", "target.rb"]
  Open3.popen2(*cmd) do |stdin, stdout, wait_thr|
    parent_pid = wait_thr.pid
    child_pid = Integer(stdout.gets)

    print "Before GC: "
    summarize_smap(child_pid)

    stdin.puts
    stdin.flush
    stdout.gets

    print " After GC: "
    summarize_smap(child_pid)

    stdin.puts
    stdin.flush
    exit_status = wait_thr.value
  end
end

run
