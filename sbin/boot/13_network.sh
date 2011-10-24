echo "NETWORK: Setting ipv4 tweaks..."
echo 0 > /proc/sys/net/ipv4/tcp_timestamps;
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse;
echo 1 > /proc/sys/net/ipv4/tcp_sack;
echo 1 > /proc/sys/net/ipv4/tcp_dsack;
echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle;
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling;
echo 5 > /proc/sys/net/ipv4/tcp_keepalive_probes;
echo 30 > /proc/sys/net/ipv4/tcp_keepalive_intvl;
echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout;
echo 4096 16384 404480 > /proc/sys/net/ipv4/tcp_wmem;
echo 4096 87380 404480 > /proc/sys/net/ipv4/tcp_rmem;
echo 4096 > /proc/sys/net/ipv4/tcp_max_syn_backlog; # default: 128
echo 2 > /proc/sys/net/ipv4/tcp_synack_retries; # default: 5
sysctl -w net.ipv4.tcp_mem="57344 57344 65536";
echo "NETWORK: Setting net/core tweaks..."
echo 524288 > /proc/sys/net/core/wmem_max;
echo 524288 > /proc/sys/net/core/rmem_max;
echo 256960 > /proc/sys/net/core/rmem_default;
echo 256960 > /proc/sys/net/core/wmem_default;
echo 1 > /proc/sys/net/ipv4/tcp_moderate_rcvbuf 
echo "NETWORK: Setting TCP buffersize tweaks..."
setprop net.tcp.buffersize.default 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.wifi 4095,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.umts 4094,87380,256960,4096,16384,256960;
