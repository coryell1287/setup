#!/usr/bin/env bash

echo -e "\n\n\t\e[1;35mBeginning testing setup.\n\n\e[0m"


npm i -D babel-jest
npm i -D enzyme
npm i -D enzyme-adapter-react-16
npm i -D jest
npm i -D react-test-renderer
npm i -D enzyme-to-json
npm i -D redux-mock-store

#############
# mkdir src #
#############
mkdir -p src/tests/__mocks__


####################
# Create jest.json #
####################
echo -e "{
  \"rootDir\": \"src\",
  \"verbose\": true,
  \"testRegex\": \"/src/tests/.*test.js$\",
  \"coverageDirectory\": \"<rootDir>/tests/__coverage__/\",
  \"setupFiles\": [
	\"<rootDir>/tests/__mocks__/polyfill.js\",
	\"<rootDir>/tests/setup.js\"
  ],
  \"transformIgnorePatterns\": [
	\"/node_modules/\"
  ],
  \"moduleDirectories\": [
	\"node_modules\"
  ],
   \"moduleNameMapper\": {
	\"\\\\\.css$\": \"<rootDir>/tests/__mocks__/CSSStub.js\",
	\"^actions(.*)$\": \"<rootDir>/actions\$1\",
	\"^reducers(.*)$\": \"<rootDir>/reducers\$1\",
	\"^components(.*)$\": \"<rootDir>/components\$1\",
	\"^styles(.*)$\": \"<rootDir>/styles\$1\"
  },
  \"coveragePathIgnorePatterns\": [
	\"<rootDir>/tests/__mocks__/polyfill.js\",
	\"<rootDir>/tests/setup.js\",
	\"<rootDir>/tests/__coverage__/\"
  ],
  \"globals\": {
	\"DEVELOPMENT\": false,
	\"FAKE_SERVER\": false
  }
}">./jest.json

echo -e "{
  \"env\": {
    \"jest\": true
  }
}">./src/tests/.eslintrc.json


echo -e "import React from 'react';
import Enzyme, { shallow, mount } from 'enzyme';

global.requestAnimationFrame = cb => {
  setTimeout(cb, 0);
};

const sessionStorageMock = {
  getItem: jest.fn(),
  setItem: jest.fn(),
  clear: jest.fn(),
};

const localStorageMock = {
  getItem: jest.fn(),
  setItem: jest.fn(),
  clear: jest.fn(),
};

global.sessionStorage = sessionStorageMock;
global.localStorage = localStorageMock;
global.window.location.reload = jest.fn();
global.React = React;
global.shallow = shallow;
global.mount = mount;">./src/tests/__mocks__/polyfill.js

echo -e "module.exports = {};">./src/tests/__mocks__/CSSStub.js

echo -e "import 'babel-polyfill';
import Enzyme from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';

Enzyme.configure({ adapter: new Adapter() });">./src/tests/setup.js


sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": "jest --coverage --watchAll --config=jest.json"/' package.json
echo -e "\n\n\t\e[1;32mLaunching testing suite.\n\n\e[0m"
npm test
