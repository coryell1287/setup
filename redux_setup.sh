#!/usr/bin/env bash

echo -e "\n\n\t\e[1;35mBeginning basic react setup.\n\n\e[0m"
#Install npm packages

# react dependencies
sudo npm install --save react react-dom react-addons-test-utils react-addons-transition-group
sudo npm install --save object-assign
sudo npm install --save es6-promise
sudo npm install --save es6-shim
sudo npm install --save whatwg-fetch

# Development dependencies
sudo npm install --save-dev babelify babel-core
sudo npm install --save-dev babel-preset-react babel-preset-es2015 babel-es6-polyfill babel-preset-stage-0 babel-preset-stage-2
sudo npm install --save-dev babel-plugin-transform-class-properties
sudo npm install --save-dev babel-plugin-transform-react-jsx

# Redux dependencies

sudo npm install --save react-redux react-route react-router-redux redux redux-devtools-extension

# ESLint development dependencies
sudo npm install --save-dev eslint eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react

sudo npm install --save-dev lodash
sudo npm install --save-dev classnames
sudo npm install --save-dev browser-sync
sudo npm install --save-dev browserify

# vinyl-source-stream is is a Virtual file that converts the readable
# stream you get from browserify into a vinyl stream that gulp is expecting to get.
# Gulp doesn't need to write a temporal file between different transformations.
sudo npm install --save-dev vinyl-source-stream