package main

import "flag"

func main() {
	port := flag.String("port", "9800", "Port to run cache server on")
	maxMemory := flag.Int64("mem", 1073741824, "Max memory limit for the cache server")
	flag.Parse()
	srv, _ := NewServer(*port, *maxMemory)
	srv.Listen()
}
