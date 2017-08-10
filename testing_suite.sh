#!/bin/bash

echo -e "\n\n\t\e[1;35mBeginning Karma setup.\n\n\e[0m"

sudo npm install --save-dev react-addons
sudo npm install --save-dev babel
sudo npm install --save-dev babel-preset-airbnb
sudo npm install --save-dev babelify
sudo npm install --save-dev browserify
sudo npm install --save-dev chai
sudo npm install --save-dev enzyme chai-enzyme
sudo npm install --save-dev karma-babel-preprocessor karma-browserify karma-phantomjs-launcher phantomjs-prebuilt
sudo npm install --save-dev karma mocha karma-mocha-reporter karma-mocha karma-sourcemap-loader karma-webpack
sudo npm install --save-dev watchify
sudo npm install --save-dev json-loader



echo -e "const path = require('path');

module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: [
      'test/**/*.js'
    ],

    preprocessors: {
      // add webpack as preprocessor
      'src/**/*.js': ['webpack', 'sourcemap'],
      'test/**/*.js': ['webpack', 'sourcemap']
    },

    webpack: { //kind of a copy of your webpack config
      devtool: 'inline-source-map', //just do inline source maps instead of the default
      module: {
        loaders: [
          {
            test: /\.js$/,
            loader: 'babel',
            exclude: path.resolve(__dirname, 'node_modules'),
            query: {
              presets: ['airbnb']
            }
          },
          {
            test: /\.json$/,
            loader: 'json',
          },
        ]
      },
      externals: {
        'react/lib/ExecutionEnvironment': true,
        'react/lib/ReactContext': true
      }
    },

    webpackServer: {
      noInfo: true //please don't spam the console when running in karma!
    },

    plugins: [
      'karma-webpack',
      'karma-jasmine',
      'karma-sourcemap-loader',
      'karma-chrome-launcher',
      'karma-phantomjs-launcher'
    ],


    babelPreprocessor: {
      options: {
        presets: ['airbnb']
      }
    },
    reporters: ['progress'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome'],
    singleRun: false,
  })
};">>./webpack.karma.js

echo "module.exports = function (config) {

  config.set({
    basePath: '',
    frameworks: ['browserify', 'mocha'],
    files: [
      'tests/**/*.test.jsx',
    ],
    preprocessors: {
      'src/**/*.jsx': ['babel', 'browserify'],
      'tests/**/*.jsx': ['babel', 'browserify'],
    },
    babelPreprocessor: {
      options: {
        presets: ['airbnb'],
      },
    },
    browserify: {
      debug: true,
      extensions: ['.jsx', '.js'],
      transform: [
        ['babelify', { presets: ['airbnb'] }],
      ],
      configure(bundle) {
        bundle.on('prebundle', () => {
          bundle.external('react/addons');
          bundle.external('react/lib/ReactContext');
          bundle.external('react/lib/ExecutionEnvironment');
        });
      },
    },
    reporters: ['mocha'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: false,
    browsers: ['PhantomJS'],
    singleRun: false,
  });
};"> karma.conf.js

#mkdir src
mkdir tests
touch src/Foo.jsx tests/Foo.test.jsx
echo "import React, { PropTypes, Component } from 'react';

class Foo extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className=\"foo\" />
    );
  }
}

export default Foo;"> ./src/Foo.jsx

echo "import React from 'react';
import { shallow } from 'enzyme';
import chai from 'chai';

import MyComponent from './MyComponent';
import Foo from './Foo';

describe('<MyComponent />', () => {
  it('renders three <Foo /> components', () => {
    const wrapper = shallow(<MyComponent />);
    expect(wrapper.find(Foo)).to.have.length(3);
  });

  it('renders an `.icon-star`', () => {
    const wrapper = shallow(<MyComponent />);
    expect(wrapper.find('.icon-star')).to.have.length(1);
  });

  it('renders children when passed in', () => {
    const wrapper = shallow(
      <MyComponent>
        <div className=\"unique\" />
      </MyComponent>
    );
    expect(wrapper.contains(<div className=\"unique\" />)).to.equal(true);
  });

  it('simulates click events', () => {
    const onButtonClick = sinon.spy();
    const wrapper = shallow(
      <Foo onButtonClick={onButtonClick} />
    );
    wrapper.find('button').simulate('click');
    expect(onButtonClick).to.have.property('callCount', 1);
  });
});
"> ./tests/Foo.test.jsx

sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/\t"test": ".\/node_modules\/karma\/bin\/karma start --single-run --browsers PhantomJS",' package.json
sed -i '/"test":/a \\t"test:watch": ".\/node_modules\/karma\/bin\/karma start --auto-watch"' package.json

echo -e "\n\n\t\e[1;32mLaunching testing suite.\n\n\e[0m"
npm test

