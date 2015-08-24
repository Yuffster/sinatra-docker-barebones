require 'sinatra'

get '/' do
  if Random.rand(5) == 4
    logger.info "Randomly crashing the server in order to demonstrate adversity."
    Thread.new { sleep 1; Process.kill 'INT', Process.pid }
    body "Random failure, crashing."
  else
    "Hello, world!\n"
  end
end
