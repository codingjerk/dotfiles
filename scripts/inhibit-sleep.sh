#/usr/bin/env sh

# Temporary disables suspend, sleep and hybernation caused by lid switch

echo "Inhibiting the sleep and lid switch actions. Press Ctrl-C to cancel..."
systemd-inhibit \
    --what=handle-lid-switch:sleep \
    --mode=block \
    --why="Keep running with lid closed" \
    --who="manual lock" \
    sleep infinity
