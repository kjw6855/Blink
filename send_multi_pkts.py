#!/usr/bin/env python

# This script requires root/administrator privileges to run.

from scapy.all import *
import sys, multiprocessing, time

def retransmit_packet(sport, num_pkts):
    eth_layer = Ether(src="00:00:0a:00:01:01", dst="00:00:0a:00:05:02")
    ip_layer = IP(src="10.0.1.1", dst="10.0.5.2")
    tcp_layer = TCP(sport=sport, dport=80, seq=2, ack=1, flags="PA")
    payload = b"TEST"
    packet = eth_layer / ip_layer / tcp_layer / payload

    startTime = next_send_time = time.time()
    i = 0
    # while (time.time() - startTime <= 60):
    while (i < num_pkts):
        sendp(packet, iface="h1-eth0", count=2, verbose=False)
        i += 1
        next_send_time += 1
        time.sleep(max(0, next_send_time - time.time()))

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 {} <num_procs> <num_packets>".format(sys.argv[0]))
        sys.exit(1)

    try:
        num_procs = int(sys.argv[1])
        num_pkts = int(sys.argv[2])
    except ValueError:
        print("Invalid number of procs/packets")
        sys.exit(1)

    procs = []
    for i in range(num_procs):
        proc = multiprocessing.Process(target=retransmit_packet, args=(10000+i, num_pkts))
        proc.daemon = True
        procs.append(proc)
        proc.start()

    for proc in procs:
        proc.join()
