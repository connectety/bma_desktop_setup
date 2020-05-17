#!/usr/bin/env bash

name="setup4bmatotp"
org="io.github.connectety"
desc="helps setting up a totp app to use as a second factor authenticator for blizzard"

flutter pub upgrade

rm .gitignore
rm -rf linux macos windows

flutter create --no-pub --project-name="$name" --org="$org" --description="$desc" .

rm test/widget_test.dart

git add linux macos windows .gitignore
