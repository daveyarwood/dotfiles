#!/bin/sh
xrandr \
  --output eDP --off \
  --output HDMI-A-0 \
  --mode 1680x1050 \
  --pos 0x0 \
  --rotate normal \
  --output DisplayPort-0 --off \
  --output DisplayPort-1 --off
