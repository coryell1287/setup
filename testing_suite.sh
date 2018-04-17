#!/bin/bash

echo -e "\n\n\t\e[1;35mBeginning testing setup.\n\n\e[0m"


npm i -D babel-jest
npm i -D enzyme
npm i -D enzyme-adapter-react-16
npm i -D jest
npm i -D react-test-renderer



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

#touch src/Foo.js tests/Foo.test.js

echo -e "tests/**/*.js">.eslintignore


sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": "jest --coverage --watch"\,/' package.json
sed -i '/"test":/a \\t"test:client": ".\/node_modules\/karma\/bin\/karma start",' package.json
sed -i '/"dependencies":/i \\t"jest": {
    "rootDir": "src/test",
    "testRegex": "/src/test/.*test\\.js$",
    "setupFiles": [
      "<rootDir>/polyfills.js",
      "<rootDir>/setup.js"
    ]
  }\,/"' package.json
echo -e "\n\n\t\e[1;32mLaunching testing suite.\n\n\e[0m"
npm test



#echo -e "import React from 'react';
#import { shallow } from 'enzyme';
#import { configure } from 'enzyme';
#import Adapter from 'enzyme-adapter-react-16';
#import { expect } from 'chai';
#
#import MyComponent from './MyComponent'
#import Foo from './Foo';
#
#configure({ adapter: new Adapter() });
#
#describe('<MyComponent/>', () => {
#  it('renders three <Foo /> components', () => {
#    const wrapper = shallow(<MyComponent />);
#    expect(wrapper.find(Foo)).to.have.length(3);
#  });
#});"> ./tests/Foo.test.js
#
#
#echo -e "import React, { Component } from 'react';
#import Foo from './Foo'
#
#export default class MyComponent extends Component {
#   render(){
#     return (
#       <div>
#         <Foo/>
#         <Foo/>
#         <Foo/>
#       </div>
#     );
#   }
#}">./tests/MyComponent.js
#
#
#echo -e "import React from 'react';
#
#export const Foo = () => {
#  return (
#    <h1>Hello</h1>
#  );
#};
#
#export default Foo;">./tests/Foo.js
