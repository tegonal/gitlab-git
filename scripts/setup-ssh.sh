#!/bin/bash
set -e

if ! [[  "${CI_REPOSITORY_URL?is required}" =~ .*@.+ ]] ; then
  echo "CI_REPOSITORY_URL needs to match .*@.+, was '$CI_REPOSITORY_URL'"
  exit 1
fi

if [[ -z "$GITBOT_SSH_PRIVATE_KEY" ]] ; then
    echo "GITBOT_SSH_PRIVATE_KEY is required"
    exit 1
fi

eval $(ssh-agent -s)
ssh-add <(echo "$GITBOT_SSH_PRIVATE_KEY") || { echo "cannot add ssh-key"; exit $?; }

export GITBOT_HOST=`echo $CI_REPOSITORY_URL | perl -pe 's#.*@([^/]+).*#\1#'`
echo "GITBOT_HOST: $GITBOT_HOST"

mkdir -p ~/.ssh
ssh-keyscan $GITBOT_HOST >> gitlab-known-hosts
cat gitlab-known-hosts >> ~/.ssh/known_hosts
git config --global user.email "$GITBOT_EMAIL"
git config --global user.name "$GITBOT_USERNAME"
git config --global --list

export GITBOT_REPO_URL=`echo $CI_REPOSITORY_URL | perl -pe 's#.*@(.+?(\:\d+)?)/#git@\1:#'`
echo "GITBOT_REPO_URL: $GITBOT_REPO_URL"

/bin/bash
