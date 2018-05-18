package main

import (
	"context"
	"log"
	"net"
	"server/goaway"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/keepalive"
	"google.golang.org/grpc/reflection"
)

const (
	port = ":50051"
)

type server struct {
	count int64
}

func (s *server) Decrement(ctx context.Context, in *goaway.DecrementRequest) (*goaway.DecrementReply, error) {
	s.count--
	return &goaway.DecrementReply{Count: s.count}, nil
}

func (s *server) Increment(ctx context.Context, in *goaway.IncrementRequest) (*goaway.IncrementReply, error) {
	s.count++
	return &goaway.IncrementReply{Count: s.count}, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	counter := new(server)
	keepalive := keepalive.ServerParameters{
		MaxConnectionIdle: 1 * time.Millisecond,
	}
	serverOpts := []grpc.ServerOption{grpc.KeepaliveParams(keepalive)}
	s := grpc.NewServer(serverOpts...)
	goaway.RegisterDecrementerServer(s, counter)
	goaway.RegisterIncrementerServer(s, counter)
	reflection.Register(s)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
