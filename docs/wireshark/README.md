# 🦈 Wireshark Database

Packet-analysis reference for authorized networks and lab environments.

## Common Display Filters

```text
ip.addr == 192.168.1.10
tcp
udp
dns
http
tls
icmp
tcp.port == 443
```

## Useful DNS Filter

```text
dns
```

## TCP SYN Packets

```text
tcp.flags.syn == 1 && tcp.flags.ack == 0
```

## Investigation Workflow

1. Identify the endpoints.
2. Identify the protocol.
3. Follow the conversation or stream.
4. Check timestamps and sequence.
5. Look for errors, resets, retransmissions, or unexpected destinations.
6. Save the original capture as evidence.

Never publish packet captures containing credentials, tokens, personal information, or other sensitive data.
