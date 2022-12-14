#! /usr/bin/env bash

context=$1

RED="\e[31m"
NC="\e[0m"
BOLD="\e[1m"

case "$context" in
    "<context>"  ) kubectl config use-context <context name>;;
    "<context>"  ) kubectl config use-context <context name>;;
    *            ) echo -e "${RED}${BOLD}Unknown context${NC}"; \
                   echo -e "Use context:\n<context> - <context name>\n<context> - <context name>"
esac
