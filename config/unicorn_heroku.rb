worker_processes 3

timeout 5

preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    Process.kill 'QUIT', Process.pid
  end
end
