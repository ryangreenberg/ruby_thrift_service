$:.push('./lib/thrift')
require 'rubygems'
gem 'thrift', '>= 0.5.0'

# Replace this require with the name of your service as it
# appears in lib/thrift. For example, if your thrift file is
# named foo.thrift, this will probably be require 'foo_service'
require 'generic_service'

SERVER_HOST = '127.0.0.1'
SERVER_PORT = 9090

puts "Starting simple client..."
print "How many parallel requests do you want to make? [1] "
parallel_requests = STDIN.gets.strip.to_i
parallel_requests = 1 if parallel_requests < 1
puts "Press enter to make a request, ctrl-c to exit"

exit = false

while true

  begin
    input = STDIN.gets
  rescue Interrupt => e
    break
  end

  begin
    parallel_requests.times do |i|
      Thread.new do
        transport = Thrift::FramedTransport.new(Thrift::Socket.new(SERVER_HOST, SERVER_PORT))
        protocol = Thrift::BinaryProtocol.new(transport)

        # You will need to change the name of your client based on the name
        # of your Thrift service. If your service is named foo.thrift, this
        # will probably be FooService::Client
        client = GenericService::Client.new(protocol)

        start = Time.now
        request = GenericRequest.new(:message => "Hello, server!")

        transport.open()
        puts "Calling service with #{request.inspect}..."
        response = client.hello(request)
        puts "Service responsed with #{response.inspect}"
        transport.close()

        puts "Request took: #{Time.now - start}s"
      end
    end
  rescue Thrift::Exception => e
    puts "Exception from service: #{e.inspect}"
  end

end

puts "\nDone"