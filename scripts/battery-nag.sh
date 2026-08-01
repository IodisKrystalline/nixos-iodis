#!/usr/bin/env bash
# Nhắc cắm sạc khi pin <= NGƯỠNG% và đang xả (không sạc).
# Được gọi lặp lại bởi systemd timer (battery-nag.timer) -> tự dừng khi cắm
# sạc vì lúc đó state != "discharging" nữa, không cần biết gì thêm.
set -euo pipefail

THRESHOLD=20

BAT="$(upower -e | grep -m1 'BAT' || true)"
[ -z "$BAT" ] && exit 0

INFO="$(upower -i "$BAT")"
PERCENT="$(grep -oP 'percentage:\s*\K[0-9]+' <<< "$INFO" || echo 100)"
STATE="$(grep -oP 'state:\s*\K\S+' <<< "$INFO" || echo unknown)"

if [ "$STATE" = "discharging" ] && [ "$PERCENT" -le "$THRESHOLD" ]; then
    notify-send -u critical -a "Battery" \
        "⚠️ Pin yếu (${PERCENT}%)" \
        "Cắm sạc ngay! Thông báo này sẽ lặp lại mỗi 30s cho tới khi bạn cắm sạc."
fi
