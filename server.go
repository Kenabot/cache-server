package main

import (
	"bufio"
	"io"
	"net"

	"github.com/KenaBot/cache-server/lru"
	"github.com/KenaBot/cache-server/parser"
	"github.com/KenaBot/cache-server/protocol"
)

// Server provides core server functionality
type Server struct {
	ln    net.Listener
	port  string
	cache *lru.Lru
}

// NewServer instantiates a new tcp server
func NewServer(port string, maxMemory int64) (*Server, error) {
	ln, err := net.Listen("tcp", ":"+port)
	if err != nil {
		return nil, err
	}
	return &Server{ln: ln, port: port, cache: lru.New(maxMemory)}, nil
}

// Listen starts the server and listens for connections on the port
func (srv *Server) Listen() error {
	for {
		conn, err := srv.ln.Accept()
		if err != nil {
			return err
		}
		go srv.handleConnection(conn)
	}
}

func (srv *Server) handleConnection(conn net.Conn) {
	defer conn.Close()

	for {
		r := bufio.NewReader(conn)
		m, err := protocol.Read(r)
		if err != nil && err != io.EOF {
			conn.Write(protocol.EncodeErr(err.Error()))
			return
		}
		qArr, err := m.Array()
		if err != nil {
			conn.Write(protocol.EncodeErr(err.Error()))
			return
		}
		q, err := parser.Parse(qArr)
		if err != nil {
			conn.Write(protocol.EncodeErr(err.Error()))
			return
		}
		switch q.Cmd {
		case "GET":
			res, ok := srv.cache.Get(q.Key)
			if !ok {
				conn.Write(protocol.EncodeNil())
			} else {
				conn.Write(protocol.EncodeStr(res))
			}
		case "SET":
			srv.cache.Set(q.Key, q.Value, q.TTL)
			conn.Write(protocol.EncodeStr("Ok"))
		case "DEL":
			srv.cache.Del(q.Key)
			conn.Write(protocol.EncodeStr("Ok"))
		default:
			conn.Write(protocol.EncodeErr("Unsupported command"))
		}
	}
}
