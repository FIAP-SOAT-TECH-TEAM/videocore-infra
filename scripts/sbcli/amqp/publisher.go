package amqp

import (
	"context"
	"errors"

	"github.com/Azure/go-amqp"
)

type Publisher struct {
	conn *amqp.Conn
}

func NewPublisher(connStr string) (*Publisher, error) {
	ctx := context.Background()
	conn, err := amqp.Dial(ctx, connStr, nil)
	if err != nil {
		return nil, err
	}
	return &Publisher{conn: conn}, nil
}

func (p *Publisher) Send(queue string, body []byte) error {
	ctx := context.Background()
	session, err := p.conn.NewSession(ctx, nil)
	if err != nil {
		return err
	}
	defer session.Close(ctx)

	sender, err := session.NewSender(ctx, queue, nil)
	if err != nil {
		return err
	}
	defer sender.Close(ctx)

	msg := amqp.NewMessage(body)

	return sender.Send(ctx, msg, nil)
}

func (p *Publisher) Close() error {
	if p.conn == nil {
		return errors.New("connection is nil")
	}
	return p.conn.Close()
}