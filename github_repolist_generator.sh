#! /usr/bin/env bash

#Enter token var $GITHUB_TOKEN
list_file="github_repo.list"

if [[ -z $GITHUB_TOKEN ]]; then
  echo '$GITHUB_TOKEN variable not specified'
  exit 1
fi

if [[ -f $list_file ]]; then
  echo file $list_file already exist
  exit 1
fi

#Two pages at all
for page in {1..2}; do
  curl -s \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    --url "https://api.github.com/orgs/<ORGANIZATION_NAME>/repos?per_page=100&page=${page}" | \ 
    jq -r '.[] | .full_name + " " + .updated_at + " " + .svn_url + " " + .description' >> ${list_file}
done

cat ${list_file} | sort -b -k2.1,2.4 -k2.6,2.8 -k2.10,2.11n | column -t -l 4 -N "Repository name","Last update time","URL","Description" | tee ${list_file}
