#!/usr/bin/env bash

set -e

flutter="flutter"

name="bma_desktop_setup"
org="io.github.connectety"
desc="helps setting up a totp app to use as a second factor authenticator for blizzard"

${flutter} pub upgrade

rm .gitignore
rm -rf linux macos windows

${flutter} create --platforms=linux,macos,windows --project-name="$name" --org="$org" --description="$desc" .

rm test/widget_test.dart

echo -e "\n# Users custom\n/.gradle/" >> .gitignore

git add linux macos windows .gitignore
