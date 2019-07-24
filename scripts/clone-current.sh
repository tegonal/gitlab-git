#!/bin/bash
set -e

echo "git clone --depth 1 --single-branch --branch $CI_COMMIT_REF_NAME $GITBOT_REPO_URL"
git clone --depth 1 --single-branch --branch $CI_COMMIT_REF_NAME $GITBOT_REPO_URL
cd $CI_PROJECT_NAME
echo " ============= last commit ================"
commit 99f76fe78286fcdeba88789ee06e7e1e8981b589
git --no-pager log
echo "==========================================="