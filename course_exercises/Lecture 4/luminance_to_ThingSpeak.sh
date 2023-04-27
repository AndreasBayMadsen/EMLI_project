#!/bin/bash
# Get luminance
luminance=$(python3 read_mcp3008.py)

# Transmit to ThingSpeak
curl -d "api_key=3PP5TILMCIPH2BTM&field1=$luminance" https://api.thingspeak.com/update
