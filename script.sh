#!/bin/sh
jq -n -r '["id","date","likes"]| @csv' > api_vk.csv
jq -r '.response.items[] | [.id, (.date | strftime("%Y-%m-%dT%H:%M:%S")), .likes.count] | @csv' api_vk.json | sort -t "," -k3 >> api_vk.csv

