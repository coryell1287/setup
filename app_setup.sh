#!/usr/bin/env bash


echo -e "\n\n\t\e[1;35mBeginning application setup...\n\n\e[0m"
#Install npm packages

# react dependencies
sudo npm i -S react react-dom
sudo npm i -S react-addons-test-utils
sudo npm i -S react-addons-transition-group
sudo npm i -S object-assign
sudo npm i -S es6-promise
sudo npm i -S es6-shim
sudo npm i -S babel-plugin-transform-runtime

# Development dependencies
sudo npm i -D babelify babel-core babel-loader
sudo npm i -D babel-preset-react
sudo npm i -D babel-plugin-transform-class-properties
sudo npm i -D babel-plugin-transform-react-jsx
sudo npm i -D babel-preset-env
sudo npm i -D babel-preset-es2017
sudo npm i -D babel-es6-polyfill
sudo npm i -D babel-preset-stage-0
sudo npm i -D babel-preset-stage-2
sudo npm i -D babel-plugin-syntax-async-function
sudo npm i -D babel-preset-airbnb
sudo npm i -D babel-plugin-add-module-exports
sudo npm i -D babel-plugin-transform-regenerator


sudo npm i -S aphrodite
# Redux dependencies

sudo npm i -S redux
sudo npm i -S react-redux
sudo npm i -S react-router
sudo npm i -S redux-async-await
sudo npm i -S redux-devtools-extension
sudo npm i -S redux-thunk redux-logger

# ESLint development dependencies
sudo npm i -D eslint
sudo npm i -D eslint-config-airbnb
sudo npm i -D eslint-plugin-import
sudo npm i -D eslint-plugin-jsx-a11y
sudo npm i -D eslint-plugin-react
sudo npm i -D eslint-plugin-babel
sudo npm i -D eslint-config-default
sudo npm i -D eslint-plugin-standard

sudo npm i -D copyfiles
sudo npm i -D sass-loader
sudo npm i -D css-loader
sudo npm i -D postcss-loader
sudo npm i -D postcss-cssnext
sudo npm i -D postcss-import
sudo npm i -D image-webpack-loader
sudo npm i -D img-loader
sudo npm i -D style-loader
sudo npm i -D file-loader
sudo npm i -D url-loader
sudo npm i -D node-sass
sudo npm i -D extract-text-webpack-plugin

sudo npm i -D lodash
sudo npm i -D classnames
sudo npm i -D rimraf

sudo npm i -D deep-freeze-strict

sudo npm i -S webpack
sudo npm i -S webpack-dev-middleware
sudo npm i -S webpack-hot-middleware

#Install server setup
sudo npm i -S axios

mkdir -p ./{public/styles,src/{store,actions,router,reducers,components,containers,api}}



#Add bootstrap to the public directory
sudo npm i -S bootstrap-css@4.0.0-alpha.5


####################
# Create the store #
####################


echo -e "import React from 'react';
import { createStore, applyMiddleware, compose } from 'redux';
import createHistory from 'history/createBrowserHistory';
import thunk from 'redux-thunk';
import { createLogger } from 'redux-logger';
import reducers from 'reducers';
import asyncAwait from 'redux-async-await';

const middleware = [thunk];

if (process.env.NODE_ENV !== 'production') {
  middleware.push(createLogger());
}

const enhancers = compose(
    window.devToolsExtension ? window.devToolsExtension() : f => f
);

export const store = createStore(
    reducers,
    enhancers,
    applyMiddleware(...middleware, asyncAwait)
);

if (module.hot) {
  module.hot.accept('../reducers/', () => {
    const nextRootReducer = require('../reducers/index').default;
    store.replaceReducer(nextRootReducer);
  });
}

export const history = createHistory();">./src/store/configureStore.jsx


################################
#      Create the routes       #
################################


echo -e "import React from 'react';
import { Router, Route } from 'react-router';
import { history } from 'store/configureStore';
import Application from 'containers/Application';

const Routes = (
  <Router history={history}>
    <Route path=\"/\" component={Application} />
  </Router>
);
export default Routes;">./src/router/router.jsx

################################
#      Create the reducer      #
################################
echo -e "import { combineReducers } from 'redux';
import serviceReducer from 'reducers/serviceReducers';

const rootReducer = combineReducers({
  serviceState: serviceReducer
});

export default rootReducer;
">./src/reducers/index.jsx


echo -e "import { combineReducers } from 'redux';

const serviceTestReducer = (state = '', action) => {
  switch (action.type) {
    case 'SUCCESSUFLLY_FETCHED_DATA':
      const { message } = action.payload.data;
      return message;
    case 'FAILED_TO_RETRIEVE_DATA':
      return action.err;
    default:
      return state;
  }
};

const progressIndicator = (state = false, action) => {
  switch (action.type) {
    case 'START_FETCHING':
      return true;
    case 'STOP_FETCHING':
      return false;
    default:
      return state;
  }
};


export default combineReducers({
  serviceTestReducer,
  progressIndicator,
});">>./src/reducers/serviceReducers.jsx

################################
#      Create the routes       #
################################


echo -e "import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { store } from 'store/configureStore';
import Routes from 'router/router';

render(
  <Provider store={store}>
    {Routes}
  </Provider>,
  document.getElementById('root')
);">./src/index.jsx

echo -e "import React, { Component } from 'react';
import { connect } from 'react-redux';
import { mapDispatchToProps, mapStateToProps } from 'containers/propConfig';


class Application extends Component {

  componentDidMount() {
    const { asyncGet } = this.props;
    asyncGet();
  }


  render() {
    const { fetchState, serviceState } = this.props;
    return (
      <div>
        {
          fetchState ? 'Loading'
            :
            <div>
              <h1>Service test</h1>
              <div>
                <span>{serviceState}</span>
              </div>
            </div>
        }
      </div>
    )
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Application)
">./src/containers/Application.jsx


################################
#     Create the propConfig    #
################################

echo -e "import { bindActionCreators } from 'redux'
import * as action from 'actions';

export function mapStateToProps(state) {
  return {
    serviceState: state.serviceState.serviceTestReducer,
    fetchState: state.serviceState.progressIndicator,
  }
}

export function mapDispatchToProps(dispatch) {
  return bindActionCreators(action, dispatch);
}">./src/containers/propConfig.js


################################
#  Create the entry point      #
################################
echo -e "import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { store } from 'store/configureStore';
import Routes from 'router/router';

render(
  <Provider store={store}>
    {Routes}
  </Provider>,
  document.getElementById('root'),
);">./src/index.jsx


#Create the index.html file

echo -e "<!doctype html>
<html lang=\"en\">
<head>
  <meta charset=\"UTF-8\">
  <meta name=\"viewport\"
        content=\"width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0\">
  <meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">
  <link rel=\"stylesheet\" href=\"styles/boostrap.min.css\">
  <link rel=\"stylesheet\" href=\"public/css/styles.css\">
  <title>Application</title>
</head>
<body>
  <div id=\"root\"></div>
  <script src=\"public/bundle.js\"></script>
</body>
</html>
">./public/index.html



#Create the postcss.config file

echo -e "module.exports = {
  plugins: {
    'postcss-import': {},
    'postcss-cssnext': {
      browsers: ['last 2 versions', '> 5%'],
    },
  },
};">./postcss.config.js


#Create the development webpack file

echo -e "const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  devtool: 'source-map',
  entry: [
    'webpack-hot-middleware/client',
    './src/index.jsx',
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/public/',
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new ExtractTextPlugin('css/styles.css'),
  ],
  resolve: {
    extensions: ['.js', '.jsx'],
    alias: {
      actions: path.join(__dirname, 'src/actions/'),
      reducers: path.join(__dirname, 'src/reducers/'),
      store: path.join(__dirname, 'src/store/'),
      router: path.join(__dirname, 'src/router/'),
      components: path.join(__dirname, 'src/components/'),
      containers: path.join(__dirname, 'src/containers/'),
      api: path.join(__dirname, 'src/api/'),
      devTools: path.join(__dirname, 'src/devTools/'),
      assets: path.join(__dirname, 'src/assets/')
    },
  },
  module: {
    rules: [{
      use: 'babel-loader',
      test: /\.jsx?$/,
      include: [path.resolve(__dirname, './src')]
    }, {
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: [
          {
            loader: 'css-loader',
            options: { importLoaders: 1 },
          },
          { loader: 'postcss-loader' },
          { loader: 'sass-loader' }
        ],
      }),
    }, {
      test: /\.(jpe?g|png|gif|svg)$/,
      use: [{
        loader: 'url-loader',
        options: {
          limit: 40000,
          name: 'assets/[name].[ext]',
          context: './images'
        }
      },
        'image-webpack-loader?{}'
      ]
    }]
  },
};">./webpack.config.dev.js


# Create the webpack production file

echo -e "const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  devtool: 'source-map',
  entry: [
    './src/index.jsx',
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/public/',
  },
  plugins: [
    new ExtractTextPlugin('css/styles.css'),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': 'production',
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        warnings: false,
      },
    }),
  ],
  resolve: {
    extensions: ['.js', '.jsx'],
    alias: {
      actions: path.join(__dirname, 'src/actions/'),
      reducers: path.join(__dirname, 'src/reducers/'),
      store: path.join(__dirname, 'src/store/'),
      router: path.join(__dirname, 'src/router/'),
      components: path.join(__dirname, 'src/components/'),
      containers: path.join(__dirname, 'src/containers/'),
      api: path.join(__dirname, 'src/api/'),
      devTools: path.join(__dirname, 'src/devTools/'),
      assets: path.join(__dirname, 'src/assets/')
    },
  },
  module: {
    rules: [{
      use: 'babel-loader',
      test: /\.jsx?$/,
      include: [path.resolve(__dirname, './src')]
    }, {
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: [
          {
            loader: 'css-loader',
            options: { importLoaders: 1 },
          },
          { loader: 'postcss-loader' },
          { loader: 'sass-loader' }
        ],
      }),
    },{
      test: /\.(jpe?g|png|gif|svg)$/,
      use: [{
        loader: 'url-loader',
        options: {
          limit: 40000,
          name: 'assets/[name].[ext]',
          context: './images'
        }
      },
        'image-webpack-loader?{}'
      ]
    }]
  },
};">./webpack.config.prod.js



#Create the dev server file

echo -e "const path = require('path');
const express = require('express');
const webpack = require('webpack');
const config = require('./webpack.config.dev');

const app = express();
const port = process.env.PORT || 3000;
const compiler = webpack(config);

app.use(require('webpack-dev-middleware')(compiler, {
  noInfo: true,
  publicPath: config.output.publicPath
}));

app.use(require('webpack-hot-middleware')(compiler));

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public/index.html'));
});

app.listen(port, 'localhost', (err) => {
  if (err) {
    console.log(err);
    return;
  }

  console.log(\`Listening at http://localhost:\${port}\`);
});">devServer.js

echo -e "{
  \"extends\": \"airbnb\",
  \"ecmaFeatures\": {
    \"jsx\": true,
    \"modules\": true
  },
  \"env\": {
    \"browser\": true,
    \"node\": true
  },
  \"parserOptions\": {
    \"ecmaVersion\": 6
  },
  \"rules\": {
    \"quotes\": [
      2,
      \"single\"
    ],
    \"strict\": [
      2,
      \"never\"
    ],
    \"babel/generator-star-spacing\": 1,
    \"babel/new-cap\": 1,
    \"babel/object-shorthand\": 1,
    \"babel/arrow-parens\": 1,
    \"babel/no-await-in-loop\": 1,
    \"react/jsx-uses-react\": 2,
    \"react/jsx-uses-vars\": 2,
    \"react/react-in-jsx-scope\": 2
  },
  \"plugins\": [
    \"babel\",
    \"react\"
  ]
}">./.eslintrc

################################
# Create the action creators   #
################################

echo -e "import { get, post } from 'api';

export const asyncGet = () => dispatch => {
  const config = {
    url: '/',
    timeout: 4000,
    onSuccess: completeFetchSuccessfully,
    onError: failedToCompleteFetch,
    headers: {
      'accept': 'application/json',
      'accept-language': 'en_US',
      'content-type': 'application/json',
    }
  };

  dispatch(get(config.url, config));

};


export const completeFetchSuccessfully = message => {
  return {
    type: 'SUCCESSUFLLY_FETCHED_DATA',
    payload: {
      data: message,
    }
  }
};

export const failedToCompleteFetch = err => {
  return {
    type: 'FAILED_TO_RETRIEVE_DATA',
    err: err.message,
  }
};

export const loadFetchIndicator = () => {
  return {
    type: 'START_FETCHING',
    isFetching: true,
  }
};

export const cancelFetchIndicator = () => {
  return {
    type: 'STOP_FETCHING',
    isFetching: false,
  }
};">./src/actions/index.jsx



###################################
#  Create the index file for async#
# services             point      #
###################################

echo -e "import axios from 'axios';
import { store } from 'store/configureStore';

const { dispatch } = store;
let host = 'http://localhost:4000/rest';

async function httpRequest(method, url, config) {
  try {
    dispatch({ type: 'START_FETCHING' });
    const { data } = await axios[method](url, config);
    data && dispatch({ type: 'STOP_FETCHING' });
    return await dispatch(config.onSuccess(data));
  } catch (err) {
    return await dispatch(config.onError(err));
  }
}

export const get = (basePath, config) => {
  return httpRequest('get', \`\${host}\${basePath}\`, config);
};

export const post = (basePath, request, config) => {
  return httpRequest('post', \`\${host}\${basePath}\`, request, config);
};

export const remove = (basePath, request, config) => {
  return httpRequest('delete', \`\${host}\${basePath}\`, request, config);
};

export const put = (basePath, request, config) => {
  return httpRequest('put', \`\${host}\${basePath}\`, request, config);
};

export const patch = (basePath, request, config) => {
  return httpRequest('patch', \`\${host}\${basePath}\`, request, config);
};">./src/api/index.js

echo -e "{
  \"sourceMaps\": \"inline\",
  \"presets\": [
    \"react\",
    \"airbnb\",
    \"env\",
    \"es2017\",
    \"stage-0\",
    \"stage-2\"
  ],
  \"plugins\": [
    \"babel-plugin-transform-class-properties\",
    \"syntax-async-functions\",
    \"transform-runtime\",
    \"add-module-exports\",
    \"transform-regenerator\"
  ]
}">./.babelrc

#sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/\t"test": ".\/node_modules\/karma\/bin\/karma start --single-run --browsers PhantomJS",' package.json
sed -i '/"test":/i \\t"build:webpack": "NODE_ENV=production webpack --config webpack.config.prod.js",' package.json
sed -i '/"build:webpack":/i \\t"build": "npm run clean && npm run build:webpack",' package.json
sed -i '/"build":/a \\t"clean": "rimraf dist",' package.json
sed -i '/"test":/i \\t"start": "node devServer.js",' package.json

echo -e "\n\n\t\e[1;32mCompleted application setup.\n\n\e[0m"

npm start
