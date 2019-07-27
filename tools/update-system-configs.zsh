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

cat > /etc/ssh/sshd_config <<EOF
PermitRootLogin no
MaxAuthTries 1
MaxSessions 10
AuthorizedKeysFile .ssh/authorized_keys dotfiles/share/ssh/authorized_keys dots/share/ssh/authorized_keys
PasswordAuthentication no
UsePAM yes
UseDSN no

Subsystem sftp internal-sftp

PrintMotd no
PrintLastLog no

ClientAliveInterval 60
ClientAliveCountMax 60
EOF
