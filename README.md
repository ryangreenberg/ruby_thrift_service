# How to Write a Simple Thrift Service in Ruby #

1. Write your `.thrift` file. You may want to use `generic.thrift` in the `examples` directory as a starting point. Limited documentation about valid types is available at http://wiki.apache.org/thrift/ThriftTypes. Better documentation is available at http://diwakergupta.github.com/thrift-missing-guide/.
2. Use `thrift --gen rb` to generate the Ruby bindings.
3. Copy the bindings from the new `gen-rb` to `ruby_thrift_service/lib`
4. By default, the server will use whatever version of Thrift that Rubygems provides. If you want to use a specific or vendored version, copy the thrift gem into vendor/thrift[version] and change the requires in server.rb and client.rb to use this version.
5. Implement each method of your server in the `ServiceHandler` in `server.rb`. If you want to test your service using a simple Ruby client, implement the client in `client.rb`.
6. Start the server with `ruby server.rb`. To test the server, you can connect with the client by using `ruby client.rb`

This skeleton is based on a blog post by Ilya Grigorik at http://www.igvita.com/2007/11/30/ruby-web-services-with-facebooks-thrift/