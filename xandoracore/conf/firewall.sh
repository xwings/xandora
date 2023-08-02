# Clear Runes
iptables -F
iptables -t nat -F

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

#Setup default policies to handle unmatched traffic
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# Allow outbound packets if state related, and inbound if established
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


#Then we lock our services so they only work from the LAN
iptables -I INPUT 1 -i tap0 -j ACCEPT
iptables -I INPUT 1 -i tap1 -j ACCEPT
iptables -I INPUT 1 -i tap2 -j ACCEPT
iptables -I INPUT 1 -i tap3 -j ACCEPT
iptables -I INPUT 1 -i tap4 -j ACCEPT
iptables -I INPUT 1 -i tap5 -j ACCEPT
iptables -I INPUT 1 -i tap6 -j ACCEPT
iptables -I INPUT 1 -i tap7 -j ACCEPT
iptables -I INPUT 1 -i tap8 -j ACCEPT
iptables -I INPUT 1 -i tap9 -j ACCEPT
iptables -I INPUT 1 -i tap30 -j ACCEPT
iptables -I INPUT 1 -i tap31 -j ACCEPT
iptables -I INPUT 1 -i tap32 -j ACCEPT
iptables -I INPUT 1 -i tap33 -j ACCEPT
iptables -I INPUT 1 -i tap34 -j ACCEPT
iptables -I INPUT 1 -i tap35 -j ACCEPT
iptables -I INPUT 1 -i tap36 -j ACCEPT
iptables -I INPUT 1 -i tap37 -j ACCEPT
iptables -I INPUT 1 -i tap38 -j ACCEPT
iptables -I INPUT 1 -i tap39 -j ACCEPT
iptables -I INPUT 1 -i eth1 -j ACCEPT
iptables -I INPUT 1 -i lo -j ACCEPT

#(Optional) Allow access to our ssh server from the WAN
iptables -A INPUT -p TCP --dport 21 -i eth0 -j ACCEPT
iptables -A INPUT -p TCP --dport 22 -i eth0 -j ACCEPT
iptables -A INPUT -p TCP --dport 80 -i eth0 -j ACCEPT

#Drop TCP / UDP packets to privileged ports
#iptables -A INPUT -p TCP ! -i ${LAN} -d 0/0 --dport 0:1023 -j DROP
#iptables -A INPUT -p UDP ! -i ${LAN} -d 0/0 --dport 0:1023 -j DROP

#Finally we add the rules for NAT
iptables -A FORWARD -i tap0 -s 192.168.100.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap1 -s 192.168.101.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap2 -s 192.168.102.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap3 -s 192.168.103.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap4 -s 192.168.104.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap5 -s 192.168.105.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap6 -s 192.168.106.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap7 -s 192.168.107.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap8 -s 192.168.108.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap9 -s 192.168.109.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap30 -s 192.168.130.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap31 -s 192.168.131.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap32 -s 192.168.132.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap33 -s 192.168.133.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap34 -s 192.168.134.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap35 -s 192.168.135.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap36 -s 192.168.136.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap37 -s 192.168.137.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap38 -s 192.168.138.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap39 -s 192.168.139.0/255.255.255.0 -j ACCEPT

iptables -A FORWARD -i tap0 -d 192.168.100.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap1 -d 192.168.101.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap2 -d 192.168.102.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap3 -d 192.168.103.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap4 -d 192.168.104.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap5 -d 192.168.105.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap6 -d 192.168.106.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap7 -d 192.168.107.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap8 -d 192.168.108.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap9 -d 192.168.109.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap30 -d 192.168.130.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap31 -d 192.168.131.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap32 -d 192.168.132.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap33 -d 192.168.133.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap34 -d 192.168.134.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap35 -d 192.168.135.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap36 -d 192.168.136.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap37 -d 192.168.137.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap38 -d 192.168.138.0/255.255.255.0 -j ACCEPT
iptables -A FORWARD -i tap39 -d 192.168.139.0/255.255.255.0 -j ACCEPT

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I FORWARD 1 -o tap0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap2 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap3 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap4 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap5 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap6 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap7 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap8 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap9 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap30 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap31 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap32 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap33 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap34 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap35 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap36 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap37 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap38 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o tap39 -m state --state RELATED,ESTABLISHED -j ACCEPT

