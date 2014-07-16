#!/bin//bash
echo "installing nightwatch in .meteor/local/build"
  cd .meteor/local/build
  npm install nightwatch@0.5.3
  cd ../../../

echo "running nightwatch from app root"
  .meteor/local/build/node_modules/nightwatch/bin/nightwatch -c ./tests/nightwatch.json $1 $2
