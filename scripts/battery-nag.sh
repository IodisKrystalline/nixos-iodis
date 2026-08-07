#!/usr/bin/env bash
# Nhắc cắm sạc khi pin <= ngưỡng và đang xả. Gọi lặp lại qua systemd timer,
# tự hết tác dụng khi cắm sạc (state đổi khỏi "discharging").
set -euo pipefail
THRESHOLD=20

BAT="$(upower -e | grep -m1 BAT || true)"
[ -z "$BAT" ] && exit 0

INFO="$(upower -i "$BAT")"
PERCENT="$(grep -oP 'percentage:\s*\K[0-9]+' <<< "$INFO" || echo 100)"
STATE="$(grep -oP 'state:\s*\K\S+' <<< "$INFO" || echo unknown)"

[ "$STATE" = "discharging" ] && [ "$PERCENT" -le "$THRESHOLD" ] && \
    notify-send -u critical -a "Battery" "⚠️ Pin yếu (${PERCENT}%)" \
        "Cắm sạc ngay! Thông báo lặp lại mỗi 30s tới khi cắm sạc."
exit 0