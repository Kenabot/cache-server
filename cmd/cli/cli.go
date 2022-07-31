package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"strings"

	"github.com/thetinygoat/DictX/protocol"
)

func encode(query string) []byte {
	query = query[:len(query)-1]
	tokens := strings.Split(query, " ")
	return protocol.EncodeArray(tokens)
}

func main() {
	port := flag.String("port", "9898", "Port on which DictX server is running")
	flag.Parse()

	conn, err := net.Dial("tcp", ":"+*port)
	if err != nil {
		log.Fatal(err)
	}
	for {
		r := bufio.NewReader(os.Stdin)
		fmt.Printf("> ")
		query, err := r.ReadString('\n')
		if err != nil && err != io.EOF {
			log.Fatal(err)
		}
		enc := encode(query)
		conn.Write(enc)
		r = bufio.NewReader(conn)
		res, err := protocol.Read(r)
		if err != nil && err != io.EOF {
			fmt.Println(err)
		} else if res.Type() == protocol.Nil {
			fmt.Println("Nil")
		} else {
			msg, _ := res.String()
			fmt.Println(msg)
		}
	}
}
