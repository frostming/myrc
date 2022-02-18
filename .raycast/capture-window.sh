#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Capture Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📷

# Documentation:
# @raycast.author Frost Ming
# @raycast.authorURL https://github.com/frostming

tmp=$(mktemp)
screencapture -Wi "$tmp" && \
    convert png:"$tmp" -background '#3f98ba' -alpha remove -alpha off "$tmp" && \
    impbcopy "$tmp"
rm "$tmp"
