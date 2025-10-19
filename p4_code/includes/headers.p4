typedef bit<48>  EthernetAddress;
typedef bit<32>  IPv4Address;
typedef bit<9>   Port_t;

// standard Ethernet header
header Ethernet_h {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}

#if DPSAN_REPORT
header Dpsan_report_h {
    bit<16>         regId;
    Port_t          portId;
    bit<1>          hasRead;
    bit<1>          hasWrite;
    bit<1>          bos;        // like MPLS bos
    bit<4>          pad0;
    bit<64>         addr;
}
#endif

// IPv4 header without options
header IPv4_h {
    bit<4>       version;
    bit<4>       ihl;
    bit<6>       dscp;
    bit<2>       ecn;
    bit<16>      totalLen;
    bit<16>      identification;
    bit<3>       flags;
    bit<13>      fragOffset;
    bit<8>       ttl;
    bit<8>       protocol;
    bit<16>      hdrChecksum;
    IPv4Address  srcAddr;
    IPv4Address  dstAddr;
}

header TCP_h {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<4>  res;
    bit<1>  cwr;
    bit<1>  ece;
    bit<1>  urg;
    bit<1>  ack;
    bit<1>  psh;
    bit<1>  rst;
    bit<1>  syn;
    bit<1>  fin;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

header ICMP_h {
   bit<8> type;
   bit<8> code;
   bit<16> checksum;
   bit<32> unused;
}


struct Parsed_packet {
    Ethernet_h          ethernet;
#if DPSAN_REPORT
    Dpsan_report_h[21]  dpsan_report;
#endif
    IPv4_h              ipv4_icmp;
    ICMP_h              icmp;
    IPv4_h              ipv4;
    TCP_h               tcp;
}
