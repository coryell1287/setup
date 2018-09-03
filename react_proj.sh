#!/usr/bin/env bash

echo -e "\n\n\t\033[1;35mBeginning application setup...\n\n\033[0m"
#Install npm packages

########################
## React dependencies ##
########################
npm i -S react
npm i -S react-dom
npm i -S react-router-dom
npm i -S react-helmet
npm i -S react-addons-transition-group
npm i -D react-addons-test-utils
npm i -S connected-react-router
npm i -D react-hot-loader

########################
## Redux dependencies ##
########################
npm i -S redux
npm i -S react-redux
npm i -S react-router
npm i -D redux-logger
npm i -S redux-async-await
npm i -S redux-thunk

########################
## Babel dependencies ##
########################
npm i -S @babel/runtime@7.0.0-beta.55
npm i -D @babel/plugin-transform-runtime
npm i -D @babel/preset-env
npm i -D @babel/plugin-transform-react-jsx
npm i -D @babel/core
npm i -D @babel/cli
npm i -D babel-loader@next
npm i -D @babel/preset-react
npm i -D @babel/plugin-proposal-class-properties
npm i -D @babel/plugin-proposal-object-rest-spread
npm i -D @babel/plugin-transform-react-jsx-source
npm i -D @babel/plugin-transform-react-constant-elements
npm i -D @babel/plugin-transform-react-inline-elements
npm i -D babel-eslint
npm i -D @babel/plugin-proposal-decorators
npm i -D @babel/polyfill
npm i -D @babel/plugin-syntax-async-generators
npm i -D @babel/plugin-transform-regenerator
npm i -D @babel/plugin-proposal-function-sent
npm i -D @babel/plugin-proposal-numeric-separator
npm i -D @babel/plugin-proposal-export-namespace-from
npm i -D @babel/plugin-proposal-throw-expressions
npm i -D @babel/plugin-syntax-dynamic-import
npm i -D @babel/plugin-syntax-import-meta
npm i -D @babel/plugin-proposal-json-strings
npm i -D babel-preset-next

##########################
## Eslint dependencies ##
#########################
npm i -D eslint
npm i -D eslint-plugin-import
npm i -D eslint-plugin-jsx-a11y
npm i -D eslint-plugin-react
npm i -D eslint-plugin-compat
npm i -D eslint-plugin-babel

##########################
## Loader dependencies ##
#########################
npm i -D css-loader
npm i -D postcss
npm i -D postcss-loader
npm i -D postcss-preset-env
npm i -D postcss-import
npm i -D style-loader
npm i -D file-loader
npm i -D url-loader
npm i -D html-loader

##########################
## Webpack dependencies ##
#########################
npm i -D extract-text-webpack-plugin
npm i -D webpack-dev-server
npm i -D copy-webpack-plugin
npm i -D clean-webpack-plugin
npm i -D html-webpack-plugin
npm i -D webpack-manifest-plugin
npm i -D mini-css-extract-plugin
npm i -D webpack
npm i -D webpack-cli
npm i -D mini-css-extract-plugin
npm i -D optimize-css-assets-webpack-plugin
npm i -D uglifyjs-webpack-plugin


##########################
## Other dependencies ##
#########################
npm i -D lodash
npm i -S es6-promise
npm i -S es5-shim
npm i -S core-decorators
npm i -S compression
npm i -S autobind-decorator
npm i -D yargs
npm i -D deep-freeze-strict
npm i -S axios
npm i -S classnames
npm i -D core-js

mkdir -p ./src/{styles,store,actions,routes,reducers,components,containers,api}

##########################
## Create babelrc file  ##
##########################
echo -e "{
  \"sourceMaps\": true,
  \"plugins\": [
	\"@babel/plugin-transform-react-jsx-source\",
    \"@babel/plugin-syntax-async-generators\",
    \"@babel/plugin-transform-regenerator\",
    \"@babel/plugin-proposal-object-rest-spread\",
	\"@babel/plugin-proposal-function-sent\",
    \"@babel/plugin-proposal-export-namespace-from\",
    \"@babel/plugin-proposal-numeric-separator\",
    \"@babel/plugin-proposal-throw-expressions\",
    \"@babel/plugin-syntax-dynamic-import\",
    \"@babel/plugin-syntax-import-meta\",
    \"@babel/plugin-transform-react-constant-elements\",
    \"@babel/plugin-transform-react-inline-elements\",
    \"@babel/plugin-proposal-json-strings\",
     [\"@babel/plugin-proposal-class-properties\", { \"loose\": false }],
     [\"@babel/plugin-proposal-decorators\", { \"legacy\": true }],
	 [\"@babel/plugin-transform-runtime\", {
      \"corejs\": false,
      \"helpers\": true,
      \"regenerator\": true,
      \"useESModules\": false
    }]
  ],
  \"presets\": [
     \"next\",
	\"@babel/preset-react\",
	[\"@babel/preset-env\", {
		\"debug\": true,
		\"loose\": true,
		\"modules\": false,
		\"useBuiltIns\": \"entry\",
	  }
	]
  ]
}">./.babelrc


#################################
#  Create browserslistrc file   #
#################################
echo -e "last 2 chrome version
last 2 firefox version
last 2 ie version
last 2 safari version
last 2 edge version">./.browserslistrc


#########################################
#  Create the entry point for the app   #
#########################################
echo -e "import React from 'react';
import { connectRouter } from 'connected-react-router';
import { render } from 'react-dom';
import { store, history } from 'store/configureStore';
import ReactHelmet from 'containers/ReactHelmet';
import Routes from 'routes';
import { Provider } from 'react-redux';
import rootReducer from 'reducers';
import { AppContainer } from 'react-hot-loader'
import 'api/serviceConfig';
import '@babel/polyfill';

const renderUI = (App) => {
  render(
    <AppContainer>
        <ReactHelmet>
          <Provider store={store}>
            <App/>
          </Provider>
        </ReactHelmet>
    </AppContainer>,
    document.getElementById('app'),
  );
};

renderUI(Routes);

if (module.hot) {
  module.hot.accept('routes', () => renderUI(Routes));
  module.hot.accept('reducers', () => store.replaceReducer(connectRouter(history)(rootReducer)));
}">./src/appLoader.js

################################
#      Create the routes       #
################################


echo -e "import React from 'react';
import { Route, Switch } from 'react-router-dom';
import { ConnectedRouter } from 'connected-react-router';

import { history } from 'store/configureStore';
import Application from 'containers/Application';

const Routes = () => (
  <ConnectedRouter history={history}>
    <Application />
  </ConnectedRouter>
);

export default Routes;">./src/routes/index.js


################################
#    Create the index page     #
################################
echo -e "<!doctype html>
<html>
<head>
  <meta charset=\"utf-8\"/>
  <title></title>
</head>
<body>
  <div id=\"app\">Loading...</div>
</body>
</html>">./src/index.html

################################
#  Create the React Helmet     #
################################
echo -e "import React, { PureComponent } from 'react';
import { Helmet } from 'react-helmet/es/Helmet';

export default class ReactHelmet extends PureComponent {

  render() {
    return (
      <div>
        <Helmet>
          <title>Project</title>
          <html lang=\"en\" />
          <meta name=\"description\" content=\"Add the project description here\" />
          <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, shrink-to-fit=no\" />
        </Helmet>
        <div>
          {React.cloneElement(this.props.children, { ...this.props })}
        </div>
      </div>
    );
  }
}">./src/containers/ReactHelmet.js

#######################################
#     Create the Application file     #
#######################################


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
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Application)">./src/containers/Application.js

################################
#  Create the serviceConfig    #
################################

echo -e "import axios from 'axios';
const successfulServiceRequest = (service) => {
  return {
    type: service.type,
    payload: {
      data: service.data,
    },
  };
};

const failedServiceRequest = (err) => {
  return {
    type: 'FAILED_SERVICE_REQUEST',
    err: err.message,
  };
};

const getBaseUrl = () => {
  const { origin, hostname, protocol, port } = window.location;
  let url;

  url = !origin
    ? \`${protocol}//${hostname}${port}/api/\`
    : \`${origin}/api/\`;
  return url;
};

const host = getBaseUrl();

axios.defaults.baseURL = host;
axios.defaults.headers.common['Content-Type'] = 'application/json';
axios.defaults.headers.common['Accept'] = 'application/json';
axios.defaults.headers.post['Content-Type'] = 'application/json';
axios.interceptors.request.use(request => request);">./src/api/serviceConfig.js

################################
#     Create the propConfig    #
################################

echo -e "import { bindActionCreators } from 'redux';
import * as action from 'actions';

export function mapStateToProps(state) {
  return {
    serviceState: state.serviceState.serviceTest,
    fetchState: state.serviceState.progressIndicator,
  };
}

export function mapDispatchToProps(dispatch) {
  return bindActionCreators(action, dispatch);
}

">./src/containers/propConfig.js


################################
# Create the action creators   #
################################

echo -e "import { get } from 'api';

export const asyncGet = () => (dispatch) => {

  const options = {
    url: '',
  };
  dispatch(get(options.url));
};">./src/actions/index.js


####################################
#  Create the index file for async #
#          services point          #
####################################

echo -e "import axios from 'axios';

const httpRequest = (method, config) => async (dispatch) => {
  try {
    dispatch({ type: 'START_FETCHING', fetching: true });
    const { data } = method === 'get'
      ? await axios[method](config.url)
      : await axios[method](config.url, config.body);
    return await dispatch(config.onSuccess(data));
  } catch (err) {
    return await dispatch(config.onError(err));
  } finally {
    dispatch({ type: 'STOP_FETCHING', fetching: false });
  }
};

export const get = (config) => httpRequest('get', config);
export const post = (config) => httpRequest('post', config);
">./src/api/index.js


################################
#      Create the store        #
################################
echo -e "import thunk from 'redux-thunk';
import { applyMiddleware, compose, createStore } from 'redux';
import createHistory from 'history/createBrowserHistory';
import { createLogger } from 'redux-logger';
import rootReducer from 'reducers';
import asyncAwait from 'redux-async-await';
import { connectRouter, routerMiddleware } from 'connected-react-router';

const middleware = [thunk];
const history = createHistory();

if (process.env.NODE_ENV === 'development') {
  middleware.push(createLogger());
}

const enhancers = compose(
  window.devToolsExtension ? window.devToolsExtension() : f => f,
);

const store = createStore(connectRouter(history)(rootReducer), enhancers, compose(
  applyMiddleware(...middleware, routerMiddleware(history), asyncAwait)));

export {
  store,
  history,
};
">./src/store/configureStore.js


################################
#      Create the reducer      #
################################
echo -e "import { combineReducers } from 'redux';
import serviceReducer from 'reducers/serviceReducers';

const rootReducer = combineReducers({
  serviceState: serviceReducer,
});

export default rootReducer;
">./src/reducers/index.js


################################
#      Create the reducer      #
################################
echo -e "import { combineReducers } from 'redux';

const serviceTest = (state = '', action) => {
  switch (action.type) {
    case 'SUCCESSFUL_SERVICE_REQUEST': {
      const { data } = action.payload;
      return data;
    }
    case 'FAILED_SERVICE_REQUEST': {
      return 'Sorry. Your request failed';
    }
    default: {
      return state;
    }
  }
};

const progressIndicator = (state = false, action) => {
  switch (action.type) {
    case 'START_FETCHING': {
      return true;
    }
    case 'STOP_FETCHING': {
      return false;
    }
    default: {
      return state;
    }
  }
};

export default combineReducers({
  serviceTest,
  progressIndicator,
});
">./src/reducers/serviceReducers.js


################################
#  Create the postcss config   #
################################
echo -e "module.exports = {
  plugins: {
    'postcss-import': {},
    'postcss-cssnext': {
      browsers: ['last 2 versions', '> 5%'],
    },
  },
};">./postcss.config.js

################################
#  Create the  eslintrc file  #
################################
echo -e "{
  \"parser\": \"babel-eslint\",
  \"extends\": [\"plugin:compat/recommended\", \"eslint:recommended\", \"plugin:react/recommended\", \"plugin:import/errors\"],
  \"parserOptions\": {
    \"ecmaVersion\": 8,
    \"ecmaFeatures\": {
      \"modules\": true
    }
  },
  \"env\": {
    \"browser\": true,
    \"node\": true
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
    \"react/prop-types\": 0,
    \"react/jsx-uses-vars\": 2,
    \"react/react-in-jsx-scope\": 2,
    \"react/jsx-filename-extension\": 0,
    \"react/prefer-stateless-function\": 2,
    \"import/no-extraneous-dependencies\": 0,
    \"jsx-a11y/href-no-hash\": \"off\",
    \"import/no-unresolved\": 0,
    \"import/extensions\": [\"error\", \"never\"],
    \"no-underscore-dangle\": [\"error\", { \"allowAfterThis\": true }]
  },
  \"plugins\": [
    \"babel\",
    \"react\",
    \"jsx-a11y\"
  ]
}
">./.eslintrc.json

################################
#  Create the Webpack config   #
################################
echo -e "const webpack = require('webpack');
const HtmlWebPackPlugin = require('html-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const { resolve } = require('path');
const yargs = require('yargs');
const postcssPresetEnv = require('postcss-preset-env');
const autoprefixer = require('autoprefixer');
const application = require('./package');

const args = yargs.argv;
const isDev = args.mode === 'development';
const isProd = args.mode !== 'development';
const environment = args.mode;
const identity = i => i;
const ifDev = then => (isDev ? then : null);
const ifProd = then => (isDev ? null : then);

module.exports = {
  target: 'web',
  profile: true,
  stats: {
    children: false,
  },
  entry: { app: './appLoader.js' },
  performance: { maxEntrypointSize: 400000 },
  context: resolve(__dirname, './src'),
  devtool: 'source-map',
  devServer: {
    port: 8000,
    host: 'localhost',
    stats: 'errors-only',
    hot: true,
    compress: true,
    historyApiFallback: true,
    disableHostCheck: true,
    contentBase: resolve(__dirname, './dist'),
    overlay: { warnings: true, errors: true },
  },
  resolve: {
    modules: [resolve(__dirname, './src'), 'node_modules'],
    extensions: ['.js', '.json', '.css'],
    alias: {
      actions: resolve(__dirname, './src/actions/'),
      api: resolve(__dirname, 'src/api/'),
      components: resolve(__dirname, './src/components/'),
      containers: resolve(__dirname, 'src/containers/'),
      fonts: resolve(__dirname, './src/fonts/'),
      images: resolve(__dirname, './src/images/'),
      reducers: resolve(__dirname, './src/reducers/'),
      routes: resolve(__dirname, 'src/routes/'),
      store: resolve(__dirname, 'src/store/'),
      styles: resolve(__dirname, './src/styles/'),
      utils: resolve(__dirname, './src/utils/'),
    },
  },
  output: {
    path: resolve(__dirname, './dist'),
    publicPath: isDev ? '/' : '',
    filename: isDev ? '[name].bundle.js' : '[name].[chunkhash].js',
  },
  optimization: {
    nodeEnv: environment,
    namedModules: true,
    minimizer: [
      ifProd(
        new UglifyJsPlugin({
          cache: true,
          parallel: true,
          sourceMap: true,
        }),
      ),
     ifProd(new OptimizeCSSAssetsPlugin({})),
    ].filter(identity),
    splitChunks: {
      cacheGroups: {
        commons: {
          name: 'common',
          chunks: 'initial',
          minChunks: 2,
          maxInitialRequests: 5,
          minSize: 0,
        },
        vendor: {
          test: /node_modules/,
          chunks: 'initial',
          name: 'vendor',
          priority: 10,
          enforce: true,
        },
      },
    },
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        },
      },
      {
        test: /\.html$/,
        use: [
          {
            loader: 'html-loader',
            options: { minimize: true },
          },
        ],
      },
      {
        test: /\.css$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: { importLoaders: 1, import: true },
          },
          {
            loader: 'postcss-loader',
            options: {
              ident: 'postcss',
              plugins: () => [
                postcssPresetEnv({ browsers: 'last 2 versions' }, autoprefixer({ grid: true })),
              ],
            },
          },
        ],
      },
      {
        test: /\.(jpe?g|png|gif|svg|ico)$/,
        use: [
          {
            loader: 'url-loader',
            options: {
              name: 'images/[name].[hash].[ext]',
              limit: 40000,
              context: './images',
            },
          },
        ],
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: isDev ? '[name].[hash].[ext]' : 'fonts/[name].[hash].[ext]',
              limit: 40000,
              useRelativePath: isDev,
            },
          },
        ],
      },
    ],
  },
  plugins: [
    ifProd(
      new ManifestPlugin({
        fileName: 'manifest.json',
        seed: {
          name: 'Assets Manifest file',
        },
      }),
    ),
    ifProd(
      new CopyWebpackPlugin([
        { from: 'fonts/', to: './fonts' },
        { from: 'images/', to: './images' },
      ]),
    ),
    new webpack.DefinePlugin({
      PRODUCTION: JSON.stringify(isProd),
      'process.env.NODE_ENV': JSON.stringify(environment),
      'process.env': {
        NODE_ENV: JSON.stringify(environment),
        application_version: JSON.stringify(application.version),
      },
    }),
    ifProd(new CleanWebpackPlugin(['dist'], { verbose: true })),
    ifDev(new webpack.HotModuleReplacementPlugin()),
    new HtmlWebPackPlugin({
      template: 'index.html',
      chunks: ['vendor', 'common', 'app'],
    }),
  ].filter(identity),
};">./webpack.config.js

echo -e "node_modules\n.idea">.gitignore

sed -i '/"test":/i \\t"start":"webpack-dev-server --mode development",' package.json
sed -i '/"start":/i \\t"build": "webpack --mode production",' package.json

echo -e "\n\n\t\033[1;32mCompleted application setup.\n\n\033[0m"

npm start
