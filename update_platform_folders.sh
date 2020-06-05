#!/usr/bin/env bash

set -e

name="setup4bmatotp"
org="io.github.connectety"
desc="helps setting up a totp app to use as a second factor authenticator for blizzard"

~/development/flutter/bin/flutter pub upgrade

rm .gitignore
rm -rf linux macos windows

~/development/flutter/bin/flutter create --project-name="$name" --org="$org" --description="$desc" .

rm test/widget_test.dart

echo -e "\n# Users custom\n/.gradle/\n/analysis_options.yaml" >> .gitignore

git add linux macos windows .gitignore
