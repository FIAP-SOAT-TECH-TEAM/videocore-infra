# sbcli – CLI AMQP 1.0

## Motivação

Este binário foi criada para simplificar a publicação de mensagens no Azure Service Bus usando **AMQP 1.0** ([Azure GO AMQP Client](https://github.com/Azure/go-amqp)), eliminando dependência de Docker, ferramentas incompatíveis ou SDKs pesados.

O objetivo é fornecer um **binário único, autocontido e versionável**, que funcione de forma previsível em ambientes locais, CI e com o Service Bus Emulator, permitindo debug e testes rápidos.

Os únicos utilitários de linha de comando, ou imagens encontradas no docker hub são para AMQP 0.9.1, resultando no seguinte erro:

```
# Exemplo com amqpcat

echo "teste" | docker run -i --rm --network docker_videocore-network cloudamqp/amqpcat -P -u "amqp://RootManageSharedAccessKey:SAS_KEY_VALUE@azure-service-bus-emulator/process.queue" -q "process.queue"

Invalid frame type 65
```

> ⚠️ Não existe um "Event Grid Emulator". Portanto, paara simular localmente é necessário realizar o fluxo de upload do vídeo para o Azurite e, então, a publicação do evento no Azure Service Bus Emulator manualmente.

## Comandos Chave

`go mod init`
`go mod tidy`
`make build`
`chmod +X sbcli`

## Como Usar

`sbcli -conn "amqp://RootManageSharedAccessKey:SAS_KEY_VALUE@localhost:5672/queue_name" -queue "queue_name"  -msg "event_payload"`