# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: decrementer.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "goaway.DecrementRequest" do
  end
  add_message "goaway.DecrementReply" do
    optional :count, :int64, 1
  end
end

module Goaway
  DecrementRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("goaway.DecrementRequest").msgclass
  DecrementReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("goaway.DecrementReply").msgclass
end