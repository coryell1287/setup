#!/usr/bin/env bash

echo -e "\n\nBeginning Karma setup.\n\n"

sudo npm install --save-dev babel
sudo npm install --save-dev babel-preset-airbnb
sudo npm install --save-dev babelify
sudo npm install --save-dev browserify
sudo npm install --save-dev chai
sudo npm install --save-dev karma-babel-preprocessor karma-browserify karma-phantomjs-launcher phantomjs-prebuilt
sudo npm install --save-dev karma karma-mocha-reporter mocha
sudo npm install --save-dev watchify


echo "module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['browserify', 'mocha'],
    files: [
      'test/**/*.test.js'
    ],
    preprocessors: {
      'src/**/*.js': ['babel', 'browserify'],
      'test/**/*.js': ['babel', 'browserify']
    },
    babelPreprocessor: {
      options: {
        presets: ['airbnb']
      }
    },
    browserify: {
      debug: true,
      transform: [
        ['babelify', { presets: ['airbnb'] }]
      ],
      configure: function(bundle) {
        bundle.on('prebundle', function() {
          bundle.external('react/lib/ReactContext');
          bundle.external('react/lib/ExecutionEnvironment');
        });
      }
    },
    reporters: ['mocha'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: false,
    browsers: ['PhantomJS'],
    singleRun: false,
  })
};
"> karma.conf.js

mkdir src tests
touch src/Foo.js test/Foo.test.js
echo "import React, { PropTypes } from 'react';

const propTypes = {};

const defaultProps = {};

class Foo extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className=\"foo\" />
    );
  }
}

Foo.propTypes = propTypes;
Foo.defaultProps = defaultProps;

export default Foo;
"> ./src/Foo.js

echo "import React from 'react';
import { shallow, mount, render } from 'enzyme';
import { expect } from 'chai';
import Foo from '../src/Foo';

describe(\"A suite\", function() {
  it(\"contains spec with an expectation\", function() {
    expect(shallow(<Foo />).contains(<div className="foo" />)).equal(true);
  });

  it(\"contains spec with an expectation\", function() {
    expect(shallow(<Foo />).is('.foo')).equal(true);
  });

  it(\"contains spec with an expectation\", function() {
    expect(mount(<Foo />).find('.foo').length).equal(1);
  });
});
"> ./tests/Foo.test.js

echo -e "\n\nLaunching testing suite.\n\n"
 sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": ".\/node_modules\/karma\/bin\/karma start --single-run --browsers Chrome",/' package.json
sed -i '/"test":/a "test:watch": ".\/node_modules\/karma\/bin\/karma start --auto-watch"' package.json
npm test