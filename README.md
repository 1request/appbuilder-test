AppBuilder Test Suite
================

#### Installation

````sh
git clone https://github.com/1request/appbuilder-test.git

cd tests

npm install nightwatch@0.5.3
npm install coffee-script
````

#### Run Your Test

Before running your test, make sure your application has been started already.

````sh
cd tests

./nightwatch.sh test.coffee
````