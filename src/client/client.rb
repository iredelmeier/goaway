#!/usr/bin/env ruby

this_dir = File.expand_path(__dir__)
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'decrementer_services_pb'
require 'incrementer_services_pb'

def decrement(stub)
  puts 'Calling first service...'
  stub.decrement(Goaway::DecrementRequest.new).count
  puts 'Called first service'
  puts 'Sleeping for 1 second...'
  sleep 1
end

def increment(stub)
  puts 'Calling second service...'
  stub.increment(Goaway::IncrementRequest.new).count
  puts 'Called second service'
  puts 'Sleeping for 1 second...'
  sleep 1
end

# rubocop:disable Metrics/MethodLength
def main
  decrementer_stub = Goaway::Decrementer::Stub.new(
    'localhost:50051',
    :this_channel_is_insecure
  )
  incrementer_stub = Goaway::Incrementer::Stub.new(
    'localhost:50051',
    :this_channel_is_insecure
  )

  decrement(decrementer_stub)
  increment(incrementer_stub)
  decrement(decrementer_stub)
  puts 'Next call receives unhandled GOAWAY'
  increment(incrementer_stub)
end

main
