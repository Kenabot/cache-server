package main

import "flag"

func main() {
	port := flag.String("port", "9898", "Port to run DictX server on")
	maxMemory := flag.Int64("mem", 1073741824, "Max memory limit for the DictX server")
	flag.Parse()
	srv, _ := NewServer(*port, *maxMemory)
	srv.Listen()
}
