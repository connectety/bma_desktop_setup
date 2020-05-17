#!/usr/bin/env bash

flutter pub upgrade

rm .gitignore
rm -rf linux macos windows

flutter create --no-pub .

rm test/widget_test.dart

git add linux macos windows .gitignore
