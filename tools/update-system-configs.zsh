setopt ERR_EXIT NO_UNSET PIPE_FAIL

# === System configs ===
if (( $UID != 0 )); then
  echo "This one should be run as root user"
  exit 1
fi

mkdir -p /usr/share/icons/default
cat > /usr/share/icons/default/index.theme <<EOF
[icon theme]
Inherits=Breeze_Snow
EOF

cat > /etc/vconsole.conf <<EOF
FONT=ter-c20n
EOF

cat > /etc/ssh/sshd_config <<EOF
PermitRootLogin no
MaxAuthTries 1
MaxSessions 10
AuthorizedKeysFile .ssh/authorized_keys dotfiles/share/ssh/authorized_keys dots/share/ssh/authorized_keys
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
UseDNS no

Subsystem sftp internal-sftp

PrintMotd no
PrintLastLog no

ClientAliveInterval 60
ClientAliveCountMax 60
EOF

cat > /etc/sysctl.d/perf.conf <<EOF
kernel.printk = 3 3 3 3

kernel.sched_migration_cost_ns = 10000000
kernel.sched_autogroup_enabled = 0

kernel.nmi_watchdog = 0

vm.swappiness = 0
vm.dirty_ratio = 5
vm.dirty_background_ratio = 1
vm.vfs_cache_pressure = 10

net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1

net.core.netdev_max_backlog = 100000
net.core.netdev_budget = 50000
net.core.netdev_budget_usecs = 5000

net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216

net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_slow_start_after_idle = 0

net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 10

net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_timestamps = 0

net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1

net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1

net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.all.log_martians = 1

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

net.ipv4.ping_group_range = 100 100
net.ipv4.ping_group_range = 0 65535
EOF
