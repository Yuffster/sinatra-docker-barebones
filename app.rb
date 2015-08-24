require 'sinatra'

get '/' do
  if Random.rand(5) == 4
    body "Random failure, crashing."
    logger.info "Randomly crashing the server in order to demonstrate adversity."
    Thread.new { sleep 1; Process.kill 'INT', Process.pid }
    halt 200
  else
    "Hello, world!\n"
  end
end
