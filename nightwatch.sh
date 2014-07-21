#!/bin/bash
FILE=$1

FEXT="${FILE##*.}"
if [ $FEXT == "coffee" ]; then
  FNAME="${FILE##*/}"
  FNAME="${FNAME%.*}"

  FILE="./lib/$FNAME.js"
  echo "compiling coffee to js"
  node_modules/coffee-script/bin/coffee --compile --output lib $1
fi

echo "running nightwatch from app root"
  nightwatch -c ./nightwatch_coffee.json -t $FILE
