#!/usr/bin/env bash


echo -e "\n\n\t\e[1;35mBeginning application setup...\n\n\e[0m"
#Install npm packages

# react dependencies
sudo npm i -S react react-dom
sudo npm i -S react-addons-test-utils
sudo npm i -S react-addons-transition-group
sudo npm install --save object-assign
sudo npm install --save es6-promise
sudo npm install --save es6-shim
sudo npm install --save whatwg-fetch
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
sudo npm i -D babel-plugin-transform-async-generator-functions
sudo npm i -D babel-plugin-syntax-async-function


sudo npm i -S aphrodite
# Redux dependencies

sudo npm install --save redux react-redux react-router redux-devtools-extension redux-thunk redux-logger

# ESLint development dependencies
sudo npm install --save-dev eslint
sudo npm install --save-dev eslint-config-airbnb
sudo npm install --save-dev eslint-plugin-import
sudo npm install --save-dev eslint-plugin-jsx-a11y
sudo npm install --save-dev eslint-plugin-react
sudo npm install --save-dev eslint-plugin-babel
sudo npm install --save-dev eslint-config-default
sudo npm install --save-dev eslint-plugin-standard


sudo npm install --save autoprefixer-loader sass-loader style-loader css-loader node-sass extract-text-webpack-plugin

sudo npm install --save-dev lodash
sudo npm install --save-dev classnames
sudo npm install --save rimraf

sudo npm install --save-dev deep-freeze-strict


sudo npm i -S webpack
sudo npm i -S webpack-dev-middleware
sudo npm i -S webpack-hot-middleware

#Install server setup
sudo npm i -S axios


######################################################
# Run these command to get react-router-redux to work#
######################################################
sudo npm i -S react-router-redux@5.0.0-alpha.6
sudo npm i -S react-router-dom@4.0.0-beta.8


mkdir -p ./src/{store,actions,router,reducers,components,containers}


####################
# Create the store #
####################


echo -e "import React from 'react';
import { createStore, applyMiddleware, compose } from 'redux';
import createHistory from 'history/createBrowserHistory';
import thunk from 'redux-thunk';
import { createLogger } from 'redux-logger';
import reducers from 'reducers';

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
    applyMiddleware(...middleware)
);

if (module.hot) {
  module.hot.accept('../reducers/', () => {
    const nextRootReducer = require('../reducers/index').default;
    store.replaceReducer(nextRootReducer);
  });
}

export const history = createHistory();
">./src/store/configureStore.jsx


################################
# Create the action creators   #
################################

echo -e "import { get, post } from 'api';

export const REQUEST_POSTS = 'REQUEST_POSTS';
export const RECEIVE_POSTS = 'RECEIVE_POSTS';
export const SELECT_REDDIT = 'SELECT_REDDIT';
export const INVALIDATE_REDDIT = 'INVALIDATE_REDDIT';

export const selectReddit = reddit => ({
  type: SELECT_REDDIT,
  reddit,
});

export const invalidateReddit = reddit => ({
  type: INVALIDATE_REDDIT,
  reddit,
});

export const requestPosts = reddit => ({
  type: REQUEST_POSTS,
  reddit,
});

export const receivePosts = (reddit, json) => ({
  type: RECEIVE_POSTS,
  reddit,
  posts: json.data.children.map(child => child.data),
  receivedAt: Date.now(),
});

const fetchPosts = reddit => dispatch => {
  dispatch(get(reddit));
  return fetch(\`https://www.reddit.com/r/\${reddit}.json\`)
  .then(response => response.json())
  .then(json => dispatch(receivePosts(reddit, json)));
};

const shouldFetchPosts = (state, reddit) => {
  const posts = state.postsByReddit[reddit];
  if (!posts) {
    return true;
  }

  if (posts.isFetching) {
    return false;
  }

  return posts.didInvalidate;
};

export const fetchPostsIfNeeded = reddit => (dispatch, getState) => {
  if (shouldFetchPosts(getState(), reddit)) {
    return dispatch(fetchPosts(reddit));
  }
};">./src/actions/index.jsx

################################
#      Create the routes       #
################################


echo -e "import React from 'react';
import { Route } from 'react-router-dom'
import { ConnectedRouter } from 'react-router-redux';
import { history } from 'store/configureStore';
import Application from 'containers/Application';

const Routes = (
  <ConnectedRouter history={history}>
    <Route path=\"/\" component={Application} />
  </ConnectedRouter>
);
export default Routes;">./src/router/router.jsx

################################
#      Create the reducer      #
################################
echo -e "import { combineReducers } from 'redux';
import { SELECT_REDDIT, INVALIDATE_REDDIT, REQUEST_POSTS, RECEIVE_POSTS } from 'actions';

const selectedReddit = (state = 'reactjs', action) => {
  switch (action.type) {
    case SELECT_REDDIT:
      return action.reddit;
    default:
      return state;
  }
};

const posts = (state = { isFetching: false, didInvalidate: false, items: [], }, action) => {
  switch (action.type) {
    case INVALIDATE_REDDIT:
      return {
        ...state,
        didInvalidate: true,
      };
    case REQUEST_POSTS:
      return {
        ...state,
        isFetching: true,
        didInvalidate: false,
      };
    case RECEIVE_POSTS:
      return {
        ...state,
        isFetching: false,
        didInvalidate: false,
        items: action.posts,
        lastUpdated: action.receivedAt,
      };
    default:
      return state;
  }
};

const postsByReddit = (state = { }, action) => {
  switch (action.type) {
    case INVALIDATE_REDDIT:
    case RECEIVE_POSTS:
    case REQUEST_POSTS:
      return {
        ...state,
        [action.reddit]: posts(state[action.reddit], action)
      };
    default:
      return state;
  }
};

const rootReducer = combineReducers({
  postsByReddit,
  selectedReddit,
});

export default rootReducer;">./src/reducers/index.jsx

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

################################
#      Create the Picker       #
################################

echo -e "import React, { PropTypes } from 'react';

const Picker = ({ value, onChange, options }) => (
  <span>
    <h1>{value}</h1>
    <select onChange={e => onChange(e.target.value)}
            value={value}>
      {options.map(option =>
        <option value={option} key={option}>
          {option}
        </option>)
      }
    </select>
  </span>
);

Picker.propTypes = {
  options: PropTypes.arrayOf(
    PropTypes.string.isRequired
  ).isRequired,
  value: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired,
};

export default Picker;">./src/components/Picker.jsx


################################
#      Create the Posts        #
################################
echo -e "import React, { PropTypes } from 'react';

const Posts = ({ posts }) => (
    <ul>
      {posts.map((post, i) =>
          <li key={i}>{post.title}</li>
      )}
    </ul>
);

Posts.propTypes = {
  posts: PropTypes.array.isRequired,
};

export default Posts;
">./src/components/Posts.jsx

echo -e "import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { selectReddit, fetchPostsIfNeeded, invalidateReddit } from 'actions';
import Picker from 'components/Picker';
import Posts from 'components/Posts';

class Application extends Component {
  static propTypes = {
    selectedReddit: PropTypes.string.isRequired,
    posts: PropTypes.array.isRequired,
    isFetching: PropTypes.bool.isRequired,
    lastUpdated: PropTypes.number,
    dispatch: PropTypes.func.isRequired,
  };

  componentDidMount() {
    const { dispatch, selectedReddit } = this.props;
    dispatch(fetchPostsIfNeeded(selectedReddit));
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.selectedReddit !== this.props.selectedReddit) {
      const { dispatch, selectedReddit } = nextProps;
      dispatch(fetchPostsIfNeeded(selectedReddit));
    }
  }

  handleChange = nextReddit => {
    this.props.dispatch(selectReddit(nextReddit))
  };

  handleRefreshClick = e => {
    e.preventDefault();

    const { dispatch, selectedReddit } = this.props;
    dispatch(invalidateReddit(selectedReddit));
    dispatch(fetchPostsIfNeeded(selectedReddit))
  };

  render() {
    const { selectedReddit, posts, isFetching, lastUpdated } = this.props;
    const isEmpty = posts.length === 0;
    return (
      <div>
        <Picker value={selectedReddit}
                onChange={this.handleChange}
                options={[ 'reactjs', 'frontend' ]} />
        <p>
          {lastUpdated &&
            <span>
              Last updated at {new Date(lastUpdated).toLocaleTimeString()}.
              {' '}
            </span>
          }
          {!isFetching &&
            <a href=\"#\"
               onClick={this.handleRefreshClick}>
              Refresh
            </a>
          }
        </p>
        {isEmpty
          ? (isFetching ? <h2>Loading...</h2> : <h2>Empty.</h2>)
          : <div style={{ opacity: isFetching ? 0.5 : 1 }}>
              <Posts posts={posts} />
            </div>
        }
      </div>
    )
  }
}

const mapStateToProps = state => {
  const { selectedReddit, postsByReddit } = state;
  const {
    isFetching,
    lastUpdated,
    items: posts
  } = postsByReddit[selectedReddit] || {
    isFetching: true,
    items: []
  }

  return {
    selectedReddit,
    posts,
    isFetching,
    lastUpdated
  }
}

export default connect(mapStateToProps)(Application)">./src/containers/Application.jsx

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
  <link rel=\"stylesheet\" href=\"static/css/styles.css\">
  <title>Application</title>
</head>
<body>
  <div id=\"root\"></div>
  <script src=\"static/bundle.js\"></script>
</body>
</html>
">./public/index.html



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
    publicPath: '/static/',
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
      test: /\.jsx?$/
    }, {
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        loader: 'css-loader'
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
};">./webpack.config.dev.js


# Create the webpack production file

echo -e "const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  devtool: 'source-map',
  entry: [
    './src/index.js',
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/static/',
  },
  plugins: [
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': production,
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        warnings: false,
      },
    }),
  ],
  module: {
    rules: [{
      use: 'babel-loader',
      test: /\.jsx?$/
    }, {
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        loader: 'css-loader'
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
};
">./webpack.config.prod.js



#Create the dev server file

echo -e "const path = require('path');
const express = require('express');
const webpack = require('webpack');
const config = require('./webpack.config.dev');

const app = express();
const port = process.env.PORT || 4000;
const compiler = webpack(config);

app.use(require('webpack-dev-middleware')(compiler, {
  noInfo: true,
  publicPath: config.output.publicPath
}));

app.use(require('webpack-hot-middleware')(compiler));

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
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
###################################
#  Create the index file for async#
# services             point      #
###################################

echo -e "import axios from 'axios'
let host = 'localhost:4000/rest/'

async function httpRequest(method, url, payload, config) {
  try {
    const response = await axios[method](url, payload, config);
    const onSuccess = await dispatch(config.[successFunction](response));
    return await onSuccess();
  } catch (err) {
    return dispatch(onError(config.[errorFunction]()));
  }
}

export const get (basePath, request, config) {
   return httpRequest('get', '\${host}\${basePath}', request)
 };

 export const delete (basePath, request, config) {
   return httpRequest('delete', '\${host}\${basePath}', request)
 };

 export const post (basePath, request, config) {
   return httpRequest('post', '\${host}\${basePath}', request)
 };

 export const put (basePath, request, config) {
   return httpRequest('put', '\${host}\${basePath}', request)
 };

 export patch (basePath, request, config) {
   return httpRequest('patch', '\${host}\${basePath}', request)
 };
"

echo -e "{
\"presets\": [\"env\", \"stage-0\",\"stage-2\",\"airbnb\", \"react\", \"es2017\"],
\"plugins\": [\"babel-plugin-transform-class-properties\", \"transform-runtime\", \"syntax-async-functions\", \"transform-async-generator-functions\"]
}">./.babelrc

sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/\t"test": ".\/node_modules\/karma\/bin\/karma start --single-run --browsers PhantomJS",' package.json
sed -i '/"test":/i \\t"build:webpack": "NODE_ENV=production webpack --config webpack.config.prod.js",' package.json
sed -i '/"build:webpack":/i \\t"build": "npm run clean && npm run build:webpack",' package.json
sed -i '/"build":/a \\t"clean": "rimraf dist",' package.json
sed -i '/"test":/i \\t"start": "node devServer.js",' package.json

echo -e "\n\n\t\e[1;32mCompleted application setup.\n\n\e[0m"

npm start
