#!/bin/bash
DPATH="/Users/network/*/Downloads"
EMAILFILE=$(ls -ladt -1 $DPATH/*.eml | head -1)
less "$EMAILFILE"
