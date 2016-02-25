#!/bin/sh

# destinations you don't want routed through Tor
NON_TOR1="10.0.101.0/24"
NON_TOR2="172.16.0.0/16"
NON_TOR3="10.0.0.0/16"

# Tor's TransPort
TRANS_PORT="9040"

# your internal interface
INT_IF="vboxnet0"

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

#iptables -A PREROUTING -t nat -i tap0 -p tcp --dport 2042 -j DNAT --to 10.0.101.101:2042
#iptables -A FORWARD -p tcp -d 10.0.101.101 --dport 2042 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

#iptables -t nat -A PREROUTING -i tap0 -p tcp --syn -j REDIRECT --to-ports 9040

#for NET in $NON_TOR2; do
# iptables -t nat -A PREROUTING -i $INT_IF -d $NET -j RETURN
#done

for NET in $NON_TOR1; do
 iptables -t nat -A PREROUTING -i $INT_IF -d $NET -j RETURN
done

for NET in $NON_TOR3; do
 iptables -t nat -A PREROUTING -i $INT_IF -d $NET -j RETURN
done

iptables -t nat -A PREROUTING -i $INT_IF -p udp --dport 53 -j REDIRECT --to-ports 53
#iptables -t nat -A PREROUTING -i $INT_IF -p udp --dport 2042 -j REDIRECT --to-ports 2042
iptables -t nat -A PREROUTING -i $INT_IF -p tcp --syn -j REDIRECT --to-ports $TRANS_PORT

echo w0000f
