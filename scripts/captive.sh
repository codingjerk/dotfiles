#/usr/bin/env sh

# Temporary disables DNS over TLS to allow captive portal detection to work

resolvectl dnsovertls wlan0 no
resolvectl dnssec wlan0 no
resolvectl domain wlan0 '~.'
resolvectl default-route wlan0 yes
resolvectl flush-caches

resolvectl status wlan0
xdg-open http://neverssl.com/

echo "Press any key to re-enable DNS over TLS..."
read -n 1 -s

resolvectl domain wlan0 ""
resolvectl default-route wlan0 no
resolvectl dnsovertls wlan0 yes
resolvectl dnssec wlan0 allow-downgrade
resolvectl flush-caches

resolvectl status wlan0
