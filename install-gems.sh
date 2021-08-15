#!/usr/bin/env bash

set -e

if [ -z ${POSTURE+x} ]; then
  echo "(POSTURE is not set. Using \"operational\" by default.)"
  posture="operational"
else
  posture=$POSTURE
fi

echo "Removing gems directory..."
rm -rf gems
echo "Removing .bundle directory..."
rm -rf .bundle
echo "Removing Gemfile.lock file..."
rm -f Gemfile.lock
echo

echo
echo "Installing gems locally (posture: $posture)"
echo '= = ='

cmd="bundle install --standalone --path=./gems"

if [ operational == "$posture" ]; then
  cmd="$cmd --without=development"
fi

echo $cmd
($cmd)

echo '- - -'
echo '(done)'
echo
