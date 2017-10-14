#!/usr/bin/env bash



echo -e "\n\n\t\e[1;35mBeginning application setup...\n\n\e[0m"
#Install npm packages

# react dependencies
sudo npm i -S react
sudo npm i -S react-dom
sudo npm i -S react-helmet
sudo npm i -S react-addons-test-utils
sudo npm i -S react-addons-transition-group
sudo npm i -S object-assign
sudo npm i -S es6-promise
sudo npm i -S es5-shim
sudo npm i -S es6-shim
sudo npm i -S babel-plugin-transform-runtime
sudo npm i -S core-decorators
sudo npm i -S compression
sudo npm i -S babel-runtime
sudo npm i  -S autobind-decorator

# Development dependencies
sudo npm i -D babelify babel-core babel-loader
sudo npm i -D babel-preset-react
sudo npm i -D babel-plugin-transform-class-properties
sudo npm i -D babel-plugin-transform-runtime
sudo npm i -D babel-plugin-transform-react-constant-elements
sudo npm i -D babel-plugin-transform-react-inline-elements
sudo npm i -D babel-preset-env
sudo npm i -D babel-eslint
sudo npm i -D babel-preset-es2017
sudo npm i -D babel-preset-es2016
sudo npm i -D babel-plugin-transform-decorators-legacy
sudo npm i -D babel-es6-polyfill
sudo npm i -D babel-preset-stage-0
sudo npm i -D babel-preset-stage-2
sudo npm i -D babel-plugin-syntax-async-function
sudo npm i -D babel-preset-airbnb
sudo npm i -D babel-plugin-add-module-exports
sudo npm i -D babel-plugin-transform-regenerator
# Redux dependencies

sudo npm i -S redux
sudo npm i -S react-redux
sudo npm i -S react-router
sudo npm i -s react-router-dom
sudo npm i -S redux-async-await
sudo npm i -S redux-thunk redux-logger
sudo npm i -S webpack-manifest-plugin


# ESLint development dependencies
sudo npm i -D eslint
sudo npm i -D eslint-config-airbnb
sudo npm i -D eslint-plugin-import
sudo npm i -D eslint-plugin-jsx-a11y
sudo npm i -D eslint-plugin-react
sudo npm i -D eslint-plugin-babel
sudo npm i -D eslint-config-default
sudo npm i -D eslint-plugin-standard
sudo npm i -g eslint-plugin-babel

sudo npm i -D sass-loader
sudo npm i -D css-loader
sudo npm i -D postcss
sudo npm i -D postcss-loader
sudo npm i -D postcss-cssnext
sudo npm i -D postcss-import
sudo npm i -D style-loader
sudo npm i -D file-loader
sudo npm i -D url-loader
sudo npm i -D node-sass
sudo npm i -D extract-text-webpack-plugin
sudo npm i -D webpack-dev-server
sudo npm i -D copy-webpack-plugin
sudo npm i -D clean-webpack-plugin
sudo npm i -D html-webpack-plugin
sudo npm i -D lodash

sudo npm i -D deep-freeze-strict
sudo npm i -D react-hot-loader@3.0.0-beta.7

#Install packages needed for the server
sudo npm i -S axios
sudo npm i -S express
sudo npm i -S webpack

mkdir -p ./src/{styles,store,actions,routes,reducers,components,containers,api}

echo -e "module.exports = process.env.NODE_ENV === 'production'
  ? require('react-hot-loader/lib/AppContainer.prod')
  : require('react-hot-loader/lib/AppContainer.dev');">./src/reactHotLoader.js

#########################################
#  Create the entry point for the app   #
#########################################
echo -e "import React from 'react';
import { render } from 'react-dom';
import { store, history } from 'store/configureStore';
import ReactHelmet from 'containers/ReactHelmet';
import Routes from 'routes';
import { Provider } from 'react-redux';
import rootReducer from 'reducers';
import HotLoader from './reactHotLoader';


const renderUI = (App) => {
  render(
    <HotLoader>
        <ReactHelmet>
          <Provider store={store}>
            <App/>
          </Provider>
        </ReactHelmet>
    </HotLoader>,
    document.getElementById('app'),
  );
};

renderUI(Routes);

if (module.hot) {
  module.hot.accept('routes', () => renderUI(Routes));
  module.hot.accept('reducers', () => store.replaceReducer(rootReducer));
}">./src/appLoader.js

################################
#      Create the routes       #
################################


echo -e "import React from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import Application from 'containers/Application';

const Routes = () => {
   return (
     <Router>
        <Route path=\"/\" component={Application} />
     </Router>
   );
};

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
    const { fetchState, serviceState: { message } } = this.props;
    return (
      <div>
        {
          fetchState ? 'Loading'
            :
            <div>
              <h1>Service test</h1>
              <div>
                <span>{message}</span>
              </div>
            </div>
        }
      </div>
    )
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Application)">./src/containers/Application.js

################################
#     Create the propConfig    #
################################

echo -e "const successfulServiceRequest = (service) => {
  return {
    type: service.type,
    payload: {
      message: service.message,
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
  let baseUrl;
  const { location: { hostname, origin } } = window;
  if (hostname !== 'localhost') {
    baseUrl = \`\${origin}/rest/\`;
    return baseUrl;
  }
  baseUrl = 'http://localhost:4000/rest/';
  return baseUrl;
};

const host = getBaseUrl();

const config = {
  url: '/',
  timeout: 4000,
  onSuccess: successfulServiceRequest,
  onError: failedServiceRequest,
  headers: {
    'Accept': 'application/json',
    'Accept-Language': 'en_US',
    'Content-Type': 'application/json',
  },
};

export {
  config,
  host,
};">./src/api/serviceConfig.js


################################
# Create the action creators   #
################################

echo -e "import { get } from 'api';
import { config } from 'api/serviceConfig';

export const asyncGet = () => (dispatch) => {

  const options = {
    ...config,
    url: '',
  };
  dispatch(get(options.url, config));
};">./src/actions/index.js


####################################
#  Create the index file for async #
#          services point          #
####################################

echo -e "import axios from 'axios';
import { store } from 'store/configureStore';

const { location: { hostname, origin } } = window;
const { dispatch } = store;

let host;
if (hostname !== 'localhost') {
  host = \`\${origin}/rest/\`;
}
host = 'http://localhost:4000/rest/';

async function httpRequest(method, url, config) {
  try {
    dispatch({ type: 'START_FETCHING' });
    const { data } = method === 'get'
      ? await axios[method](url, config)
      : await axios[method](url, config.body, config);
    return await dispatch(config.onSuccess(data));
  } catch (err) {
    return await dispatch(config.onError(err));
  } finally {
    dispatch({ type: 'STOP_FETCHING' });
  }
}

export const get = (basePath, config) => {
  return httpRequest('get', \`\${host}\${basePath}\`, config);
};

export const post = (basePath, body, config) => {
  return httpRequest('post', \`\${host}\${basePath}\`, body, config);
};
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

const middleware = [thunk];

if (process.env.NODE_ENV === 'development') {
  middleware.push(createLogger());
}

const enhancers = compose(
  window.devToolsExtension ? window.devToolsExtension() : f => f,
);

const store = createStore(rootReducer, enhancers, compose(
  applyMiddleware(...middleware, asyncAwait)));

const history = createHistory();
export {
  store,
  history
};">./src/store/configureStore.js


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
      const { message } = action.payload;
      return message;
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
  \"extends\": [\"eslint:recommended\", \"plugin:react/recommended\", \"eslint-config-airbnb\"],
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
">./.eslintrc

################################
#  Create the Webpack config   #
################################
echo -e "const { resolve } = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');

const identity = i => i;

module.exports = (env) => {
  console.log(\`Env is \${env}\`);

  const isDev = env === 'dev';
  const isProd = env !== 'dev';

  const ifEnv = (condition1, condition2) => (isDev ? condition1 : condition2);

  const ifDev = then => (isDev ? then : null);
  const ifProd = then => (env === 'prod' ? then : null);
  const vendor = [
    'react',
    'redux',
    'lodash',
    'es5-shim',
    'es6-shim',
    'react-dom',
    'react-redux',
    'redux-thunk',
    'react-router',
    'react-helmet',
  ];
  const app = [
    ifDev('react-hot-loader/patch'),
    ifDev('webpack-dev-server/client?http://localhost:8000'),
    ifDev('webpack/hot/only-dev-server'),
    './appLoader'].filter(identity);

  return {
    target: 'web',
    profile: true,
    stats: {
      children: false,
    },
    entry: { vendor, app },
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
      modules: [
        resolve(__dirname, './src'),
        'node_modules',
      ],
      extensions: ['.ts', '.tsx', '.js', '.jsx', '.json'],
      alias: {
        actions: resolve(__dirname, './src/actions/'),
        api: resolve(__dirname, 'src/api/'),
        components: resolve(__dirname, './src/components/'),
        containers: resolve(__dirname, 'src/containers/'),
        dataservices: resolve(__dirname, './src/dataservices/'),
        reducers: resolve(__dirname, './src/reducers/'),
        images: resolve(__dirname, './src/images/'),
        fonts: resolve(__dirname, './src/fonts/'),
        routes: resolve(__dirname, 'src/routes/'),
        stores: resolve(__dirname, 'src/stores/'),
        styles: resolve(__dirname, './src/styles/'),
      },
    },
    output: {
      publicPath: '',
      path: resolve(__dirname, './dist'),
      filename: ifEnv('[name].bundle.js', '[name].[chunkhash].js'),
    },
    plugins: [
      new webpack.optimize.CommonsChunkPlugin({
        name: ['vendor'],
        minChunks: Infinity,
      }),
      ifProd(new webpack.optimize.UglifyJsPlugin()),
      ifProd(new CleanWebpackPlugin(['dist'], { verbose: true })),
      ifProd(new CopyWebpackPlugin([
        { from: 'fonts/', to: './fonts' },
        { from: 'images/', to: './images' },
      ])),
      new webpack.EnvironmentPlugin({
        DEBUG: isDev,
        NODE_ENV: ifEnv('development', 'production'),
      }),
      ifProd(new ManifestPlugin({
        fileName: 'manifest.json',
        seed: {
          name: 'Assets Manifest file',
        },
      })),
      new HtmlWebpackPlugin({
        template: 'index.html',
        inject: true,
        minify: {
          collapseWhitespace: true,
        },
      }),
      ifDev(new webpack.HotModuleReplacementPlugin()),
      ifDev(new webpack.NamedModulesPlugin()),
      new ExtractTextPlugin({
        filename: ifEnv('[name].bundle.[contenthash].css', 'styles/[name].bundle.[contenthash].css'),
        disable: isDev,
      }),
    ].filter(identity),
    module: {
      rules: [{
        use: 'babel-loader',
        test: /\.jsx?$/,
        include: [resolve(__dirname, './src')],
      }, {
        test: /\.(sass|scss|css)$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            {
              loader: 'css-loader',
              options: {
                sourceMap: isDev,
                importLoaders: 1,
                modules: true,
                url: true,
                minimize: isDev ? false : { discardComments: { removeAll: true } },
              },
            },
            {
              loader: 'sass-loader',
              options: {
                sourceMap: isDev,
                paths: [resolve(__dirname, 'node_modules'), resolve(__dirname, 'src')],
              },

            },
            { loader: 'postcss-loader' },
          ],
        }),
      }, {
          test: /\.(jpe?g|png|gif|svg|ico)$/,
          use: [{
            loader: 'url-loader',
            options: {
              name: 'images/[name].[ext]',
              limit: 40000,
              context: './images',
            },
          },
          ],
        }, {
       test: /\.(woff|woff2|eot|ttf|otf)$/,
        use: [{
          loader: 'file-loader',
          options: {
            name: '[name].[ext]',
            useRelativePath: isProd,
          },
        },
        ],
      },
      ],
    },
  };
};">./webpack.config.js



echo -e "{
  \"sourceMaps\": true,
    \"plugins\": [
      \"transform-runtime\",
      \"transform-decorators-legacy\",
      [\"transform-object-rest-spread\", { \"useBuiltIns\": true }],
      [\"transform-class-properties\", { \"spec\": true }],
      [\"add-module-exports\"]
    ],
  \"presets\": [
    \"react\",
    \"airbnb\",
    \"es2017\",
    \"stage-0\",
    \"stage-1\",
    \"stage-2\",
    \"stage-3\",
    [\"env\", {
      \"debug\": true,
      \"loose\": true,
      \"modules\": false,
      \"useBuiltIns\": true,
      \"targets\": {
        \"browsers\": [\"> 5%\", \"last 2 versions\"],
        \"browsers\": [\"> 5%\", \"last 2 versions\"],
        \"node\": \"8.2.0\"
      },
      \"production\":{
        \"presets\":[
          \"transform-react-constant-elements\",
          \"transform-react-inline-elements\"
        ]
      }
    }]
  ]
}
">./.babelrc

#sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/\t"test": ".\/node_modules\/karma\/bin\/karma start --single-run --browsers PhantomJS",' package.json
sed -i '/"test":/i \\t"start":"webpack-dev-server --env=dev --compress",' package.json
sed -i '/"start":/i \\t"build": "webpack --env=prod",' package.json

echo -e "\n\n\t\e[1;32mCompleted application setup.\n\n\e[0m"

npm start
