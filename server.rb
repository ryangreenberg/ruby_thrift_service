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
  def hello(request)
    log(request)
    GenericResponse.new(:message => "Hello, client, at #{Time.now.to_s}!")
  end

  private

  def log(request)
    puts "Request #{Time.now}: #{request.inspect}"
  end
end

handler = ServiceHandler.new

# You will need to change the name of your processor based on the name
# of your Thrift service. If your service is named foo.thrift, this
# will probably be FooService::Client
processor = GenericService::Processor.new(handler)
server_transport = Thrift::ServerSocket.new(SERVER_PORT)
transport_factory = Thrift::FramedTransportFactory.new

# A SimpleServer will only be able to serve a single request at a time
# You can use a ThreadedServer or a ThreadPoolServer to handle multiple
# simultaneous requests, keeping in mind that the methods of the ServiceHandler
# must be careful with respect to accessing shared resources.
server = Thrift::SimpleServer.new(processor, server_transport, transport_factory)
# server = Thrift::ThreadedServer.new(processor, server_transport, transport_factory)
# server = Thrift::ThreadPoolServer.new(processor, server_transport, transport_factory)

puts "Starting service using #{server.class}..."
puts "Listening on port #{SERVER_PORT}"
puts "(ctrl-c to stop)"

begin
  server.serve
rescue Interrupt => e
end
puts "\nDone"