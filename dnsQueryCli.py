import socket
import sys

def dnsQuery(q):
    dns_server_ip = '127.0.0.1'
    dns_server_port = 5353
    size = 1024
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((dns_server_ip, dns_server_port))
    msg = 'domain:' + q
    s.send(msg.encode())
    data = s.recv(size)
    print(data)
    s.close()

if __name__ == "__main__":
    dnsQuery( sys.argv[1] )
    # python3 dnsQueryCli.py holisticsecurity.io