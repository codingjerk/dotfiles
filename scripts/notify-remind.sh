#!/bin/sh

body=${1-}
title="Remind: $(TZ=Asia/Bangkok date +%H:%M)"

exec /usr/bin/notify-send \
    -a remind \
    -c remind \
    "$title" \
    "$body"
