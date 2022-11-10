#!/usr/bin/env bash
#
#    __                          __
#   / /____ ___ ____  ___  ___ _/ /       This script is provided to you by https://github.com/tegonal/gitlab-git
#  / __/ -_) _ `/ _ \/ _ \/ _ `/ /        It is licensed under Apache License 2.0
#  \__/\__/\_, /\___/_//_/\_,_/_/         Please report bugs and contribute back your improvements
#         /___/
#                                         Version: v0.10.0-SNAPSHOT
#
###################################
set -euo pipefail
shopt -s inherit_errexit
unset CDPATH

if ! [[  "${CI_REPOSITORY_URL?is required}" =~ .*@.+ ]] ; then
  echo "CI_REPOSITORY_URL needs to match .*@.+, was '$CI_REPOSITORY_URL'"
  exit 1
fi

if [[ -z "$GITBOT_SSH_PRIVATE_KEY" ]] ; then
    echo "GITBOT_SSH_PRIVATE_KEY is required"
    exit 1
fi

eval "$(ssh-agent -s)"
ssh-add <(echo "$GITBOT_SSH_PRIVATE_KEY" | tr -d '\r') || { echo "cannot add ssh-key"; exit $?; }

declare GITBOT_HOST
GITBOT_HOST=$(echo "$CI_REPOSITORY_URL" | perl -pe 's#.*@([^/]+).*#\1#')
export GITBOT_HOST
echo "GITBOT_HOST: $GITBOT_HOST"

mkdir -p ~/.ssh
ssh-keyscan "$GITBOT_HOST" >> ~/.ssh/known_hosts
git config --global user.email "${GITBOT_EMAIL:=Tegonal GitBot}"
git config --global user.name "${GITBOT_USERNAME:=gitbot@tegonal.com}"
git config --global --list

declare GITBOT_REPO_URL
GITBOT_REPO_URL=$(echo "$CI_REPOSITORY_URL" | perl -pe 's#.*@(.+?(\:\d+)?)/#git@\1:#')
export GITBOT_REPO_URL
echo "GITBOT_REPO_URL: $GITBOT_REPO_URL"

git remote rm origin && git remote add origin "$GITBOT_REPO_URL"

/bin/bash
