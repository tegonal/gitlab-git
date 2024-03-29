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

if [[ -z $CI_COMMIT_REF_NAME ]] ; then
    echo "$CI_COMMIT_REF_NAME is required"
    exit 1
fi

if [[ -z $GITBOT_REPO_URL ]] ; then
    echo "$GITBOT_REPO_URL is required"
    exit 1
fi

echo "git clone --depth 1 --single-branch --branch $CI_COMMIT_REF_NAME $GITBOT_REPO_URL"
git clone --depth 1 --single-branch --branch "$CI_COMMIT_REF_NAME" "$GITBOT_REPO_URL"
cd "$CI_PROJECT_NAME"
echo "================ last commit =================="
git --no-pager log
echo "==============================================="