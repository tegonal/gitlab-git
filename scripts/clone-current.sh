#!/bin/bash
set -e

echo "git clone --depth 1 --single-branch --branch $CI_COMMIT_REF_NAME $GITBOT_REPO_URL"
git clone --depth 1 --single-branch --branch $CI_COMMIT_REF_NAME $GITBOT_REPO_URL
cd $CI_PROJECT_NAME
echo " ============= last commit ================"
git --no-pager log
echo "==========================================="