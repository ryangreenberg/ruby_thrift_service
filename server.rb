$:.push('./lib/thrift')
require 'rubygems'
gem 'thrift', '>= 0.5.0'

# Replace this require with the name of your service as it
# appears in lib/thrift. For example, if your thrift file is
# named foo.thrift, this will probably be require 'foo_service'
require 'generic_service'

SERVER_PORT = 9090

# Implementation of Thrift service
#
# ServiceHandler should have a method for each call exposed by your
# Thrift service in the .thrift definition
#
# You may want a more descriptive class name than ServiceHandler
class ServiceHandler
  def initialize
    @log = {}
  end

  def hello(request)
    GenericResponse.new(:message => "Hello, client, at #{Time.now.to_s}!")
  end
end

# Thrift provides mutiple communication endpoints
#  - Here we will expose our service via a TCP socket
#  - The server will run as a single thread, on port 9090

handler = ServiceHandler.new
# You will need to change the name of your processor based on the name
# of your Thrift service. If your service is named foo.thrift, this
# will probably be FooService::Client
processor = GenericService::Processor.new(handler)
transport = Thrift::ServerSocket.new(SERVER_PORT)
transportFactory = Thrift::FramedTransportFactory.new
server = Thrift::SimpleServer.new(processor, transport, transportFactory)

puts "Starting the server..."
puts "Listening on port #{SERVER_PORT}"
puts "(ctrl-c to stop)"

begin
  server.serve
rescue Interrupt => e
end
puts "Done"