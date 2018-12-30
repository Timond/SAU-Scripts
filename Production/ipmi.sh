#!/bin/bash
JAVAFILE=$(ls -t1 ~/Downloads/*.jnlp | head -1);
EXCEPTIONLIST='/Users/network/tim.duncan/Library/Application Support/Oracle/Java/Deployment/security/exception.sites';

if [[ $JAVAFILE = *"launch"* ]]; then
	for x in `cat "$JAVAFILE"  | grep codebase | cut -d\" -f4`;
		do
			if [ $(grep -q $x "$EXCEPTIONLIST" ; echo $?) != 0 ]; then
				echo $x >> "$EXCEPTIONLIST";	
			fi;
		done;
fi;

if [[ $JAVAFILE = *"viewer"* ]]; then
	for x in `cat "$JAVAFILE"  | grep codebase | cut -d\" -f4 | cut -d '/' -f1-3`;
		do
			if [ $(grep -q $x "$EXCEPTIONLIST" ; echo $?) != 0 ]; then
				echo $x >> "$EXCEPTIONLIST";
			fi;
		done;
fi;

javaws "$JAVAFILE";

unset JAVAFILE EXCEPTIONLIST x
