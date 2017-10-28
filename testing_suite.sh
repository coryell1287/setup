#!/bin/bash

echo -e "\n\n\t\e[1;35mBeginning Karma setup.\n\n\e[0m"


sudo npm i -D mocha
sudo npm i -D sinon
sudo npm i -D react-addons-test-utils
sudo npm i -D chai
sudo npm i -D enzyme chai-enzyme
sudo npm i -D enzyme-adapter-react-16
sudo npm i -D karma-webpack
sudo npm i -D karma-sourcemap-loader
sudo npm i -D karma-phantomjs-launcher
sudo npm i -D karma-nyan-reporter
sudo npm i -D babel-cli
sudo npm i -D babel-polyfill
sudo npm i -D babel-register
sudo npm i -D json-loader
sudo npm i -D karma
sudo npm i -D karma-babel-preprocessor
sudo npm i -D karma-chrome-launcher
sudo npm i -D karma-mocha
sudo npm i -D karma-verbose-reporter
sudo npm i -D karma-htmlfile-reporter

sudo npm i -g karma-cli

echo "const path = require('path');

module.exports = (config) => {
  config.set({
    basePath: '',
    browsers: ['PhantomJS'],
    frameworks: ['mocha'],
    files: [
      'node_modules/babel-polyfill/dist/polyfill.js',
      'tests/**/*.js',
    ],

    preprocessors: {
      'src/appLoader.js': ['webpack', 'sourcemap'],
      'tests/**/*.js': ['webpack', 'sourcemap'],
    },

    webpack: {
      devtool: 'inline-source-map',
      module: {
        loaders: [
          {
            test: /\.js$/,
            loader: 'babel-loader',
            exclude: path.resolve(__dirname, 'node_modules'),
            query: {
              plugins: ['transform-decorators-legacy', 'transform-regenerator'],
              presets: ['react', 'airbnb', 'es2017', 'stage-0', 'stage-1', 'stage-2', 'stage-3'],
            },
          },
          {
            test: /\.json$/,
            loader: 'json-loader',
          },
        ],
      },
      externals: {
        'react/addons': true,
        'react/lib/ExecutionEnvironment': true,
        'react/lib/ReactContext': true,
      },
    },

    htmlReporter: {
      outputFile: 'tests/units.html',
      pageTitle: 'Unit Tests',
      subPageTitle: 'A sample project description',
      groupSuites: true,
      useCompactStyle: true,
      useLegacyStyle: true,
    },

    webpackServer: {
      noInfo: true,
    },

    reporters: ['nyan', 'verbose', 'html'],

    nyanReporter: {
      suppressErrorHighlighting: true,
      suppressErrorReport: true,
      renderOnRunCompleteOnly: false,
    },

    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: false,
    singleRun: true,
  });
};"> karma.conf.js

#mkdir src
mkdir tests
touch src/Foo.js tests/Foo.test.js

echo -e "tests/**/*.js">.eslintignore

echo -e "import React from 'react';
import { shallow } from 'enzyme';
import { configure } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { expect } from 'chai';

import MyComponent from './MyComponent'
import Foo from './Foo';

configure({ adapter: new Adapter() });

describe('<MyComponent/>', () => {
  it('renders three <Foo /> components', () => {
    const wrapper = shallow(<MyComponent />);
    expect(wrapper.find(Foo)).to.have.length(3);
  });
});"> ./tests/Foo.test.js


echo -e "import React, { Component } from 'react';
import Foo from './Foo'

export default class MyComponent extends Component {
   render(){
     return (
       <div>
         <Foo/>
         <Foo/>
         <Foo/>
       </div>
     );
   }
}">./tests/MyComponent.js


echo -e "import React from 'react';

export const Foo = () => {
  return (
    <h1>Hello</h1>
  );
};

export default Foo;">./tests/Foo.js

sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": ".\/node_modules\/karma\/bin\/karma start"/' package.json
echo -e "\n\n\t\e[1;32mLaunching testing suite.\n\n\e[0m"
npm test
