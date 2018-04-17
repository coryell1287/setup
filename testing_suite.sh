#!/usr/bin/env bash

echo -e "\n\n\t\e[1;35mBeginning testing setup.\n\n\e[0m"


npm i -D babel-jest
npm i -D enzyme
npm i -D enzyme-adapter-react-16
npm i -D jest
npm i -D react-test-renderer
npm i -D core-js

#mkdir src
mkdir src/tests

echo -e "{
  \"env\": {
    \"jest\": true
  }
}"> src/tests/.eslintrc.json


echo -e "/**
 * @fileOverview Polyfills for tests.
 */

/**
 * Temp workaround.
 * See https://github.com/facebook/jest/issues/4545#issuecomment-332762365
 */
global.requestAnimationFrame = (cb) => {
  setTimeout(cb, 0);
};">src/tests/polyfills.js

echo -e "import 'babel-polyfill';
import Enzyme from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';

Enzyme.configure({ adapter: new Adapter() });">src/tests/setup.js


sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": "jest --coverage --watch"/' package.json
sed -i '/"dependencies":/i \\t"jest": { "rootDir": "src/tests", "testRegex": "/src/tests/.*test.js$", "setupFiles": [ "<rootDir>/polyfills.js", "<rootDir>/setup.js" ] }\,' package.json
echo -e "\n\n\t\e[1;32mLaunching testing suite.\n\n\e[0m"
npm test
