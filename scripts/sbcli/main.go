package main

import (
	"flag"
	"log"

	"sbcli/amqp"
)

func main() {
	var (
		conn  = flag.String("conn", "", "Service Bus connection string")
		queue = flag.String("queue", "", "Queue or topic name")
		msg   = flag.String("msg", "", "Mensagem a ser enviada")
	)

	flag.Parse()

	if *conn == "" || *queue == "" || *msg == "" {
		log.Fatal("conn, queue e msg são obrigatórios")
	}

	pub, err := amqp.NewPublisher(*conn)
	if err != nil {
		log.Fatal(err)
	}
	defer pub.Close()

	if err := pub.Send(*queue, []byte(*msg)); err != nil {
		log.Fatal(err)
	}
}