#! /usr/bin/env bash

registry=$1
keydir="<path to folder with keys>"

GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"
BOLD="\e[1m"

case "$registry" in
    "<one>"    ) cat ${keydir}/${registry}.json | docker login --username json_key --password-stdin cr.yandex && \
                      echo -e "to ${GREEN}${BOLD}${registry}${NC} registry";;
    "<two>"    ) cat ${registry}.json | docker login --username json_key --password-stdin cr.yandex && \
                      echo -e "to ${GREEN}${BOLD}${registry}${NC} registry";;
    "<three>"  ) cat ${registry}.json | docker login --username json_key --password-stdin cr.yandex && \
                      echo -e "to ${GREEN}${BOLD}${registry}${NC} registry";;
    *          ) echo -e "${RED}${BOLD}Unknown registry${NC}"
esac
