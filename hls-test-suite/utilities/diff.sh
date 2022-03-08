#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

DIFF=$(diff -q $1 $2)
if [ "$DIFF" != "" ]; then
	echo -e "    ${RED}FAILURE${NC}"
	exit -1;
else
	echo -e "    ${GREEN}SUCCESS${NC}"
fi
