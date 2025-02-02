#!/bin/bash

rm /tmp/.X0-lock

RESOLUTION=${RESOLUTION:-"1280x1024x24"}
/usr/bin/Xvfb :0 -screen 0 $RESOLUTION