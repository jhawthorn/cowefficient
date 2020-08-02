require "open3"

RUBY_PATH = RbConfig.ruby

def summarize_smap(pid)
  data = File.read("/proc/#{pid}/smaps")
  puts data
end

def run
  cmd = [RUBY_PATH, "--disable-gems", "target.rb"]
  Open3.popen2(*cmd) do |stdin, stdout, wait_thr|
    parent_pid = wait_thr.pid
    child_pid = Integer(stdout.gets)
    p(parent: parent_pid, child: child_pid)
    summarize_smap(child_pid)
    exit_status = wait_thr.value
  end
end

run
