#!/bin/bash
INPUT="$1"
php -r 'echo(urldecode("'$INPUT'"));'
