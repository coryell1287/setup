#!/bin/bash

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

sudo npm install --save redux react-redux react-route react-router-redux redux-devtools-extension

# ESLint development dependencies
sudo npm install --save-dev eslint eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react


sudo npm install --save autoprefixer-loader sass-loader style-loader css-loader extract-text-webpack-plugin


sudo npm install --save-dev lodash
sudo npm install --save-dev classnames
#sudo npm install --save-dev browser-sync
#sudo npm install --save-dev browserify

# vinyl-source-stream is is a Virtual file that converts the readable
# stream you get from browserify into a vinyl stream that gulp is expecting to get.
# Gulp doesn't need to write a temporal file between different transformations.
#sudo npm install --save-dev vinyl-source-stream

sudo npm install --save-dev webpack webpack-dev-middleware webpack-hot-middleware

mkdir -p ./src/{store,actions,router,reducers,components}

echo -e "// Increment
export function increment(index) {
  return {
    type: 'INCREMENT_LIKES',
    index
  }
}

// Add comment
export function addComment(postId, author, comment) {
  return {
    type: 'ADD_COMMENT',
    postId,
    author,
    comment
  }
}

// Remove comment
export function removeComment(postId, i) {
  return {
    type: 'REMOVE_COMMENT',
    i,
    postId
  }
}">>./src/actions/actionCreators.jsx

echo -e "// A reducer takes in 2 things:
// 1. Action
// 2. Copy of current state

function postComments(state = [], action) {
  switch (action.type) {
    case 'ADD_COMMENT':
      // return the new state with the new comment
      return [...state, {
        user: action.author,
        text: action.comment
      }];
    case 'REMOVE_COMMENT':
      // we need to return the new state without the deleted comment
      return [
        // from the start to the one we want to delete
        ...state.slice(0, action.i),
        // after the deleted one, to the end
        ...state.slice(action.i + 1)
      ];
    default:
      return state;
  }
  return state;
}

function comments(state = [], action) {
  if (typeof action.postId !== 'undefined') {
    return {
      // take the current state
      ...state,
      // overwrite this post with a new one
      [action.postId]: postComments(state[action.postId], action)
    }
  }
  return state;
}

export default comments;">>./src/reducers/comment.jsx

echo -e "import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';

import posts from './posts';
import comments from './comments';

const rootReducer = combineReducers({posts, comments, routing: routerReducer });

export default rootReducer;">>./src/reducers/index.js


echo -e "import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as action from '../actions/actionCreators';
import Main from './Main';

function mapStateToProps(state) {
  return {
    posts: state.posts,
    comments: state.comments
  }
}

function mapDispachToProps(dispatch) {
  return bindActionCreators(action, dispatch);
}

const App = connect(mapStateToProps, mapDispachToProps)(Main);

export default App;">>./src/config/propsConfig.js

echo -e "import { createStore, compose } from 'redux';
import { syncHistoryWithStore} from 'react-router-redux';
import { browserHistory } from 'react-router';

// import the root reducer
import rootReducer from './reducers/index';

import comments from './data/comments';
import posts from './data/posts';

// create an object for the default data
const defaultState = {
  posts,
  comments
};

const enhancers = compose(
  window.devToolsExtension ? window.devToolsExtension() : f => f
);

const store = createStore(rootReducer, defaultState, enhancers);

export const history = syncHistoryWithStore(browserHistory, store);

if(module.hot) {
  module.hot.accept('./reducers/',() => {
    const nextRootReducer = require('./reducers/index').default;
    store.replaceReducer(nextRootReducer);
  });
}

export default store;
">>./src/store/store.jsx


echo -e "import React from 'react';
import { render } from 'react-dom';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import { Provider } from 'react-redux';
import store, { history } from './store';

const router = (
  <Provider store={store}>
    <Router history={history}>
      <Route path=\"/\" component={App}>
        <IndexRoute component={PhotoGrid} />
        <Route path=\"/view/:postId\" component={Single} />
      </Route>
    </Router>
  </Provider>
);
export default router;
">>./src/routes/routes.jsx


echo -e "const path = require('path');
const webpack = require('webpack');
const srcPath = path.join(__dirname, './src');

module.exports = {
  devtool: 'source-map',
  entry: [
    'webpack-hot-middleware/client',
    './src/index.jsx'
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/public/'
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
  resolve: {
  extensions: ['', '.js', '.jsx'],
  root: path.resolve(__dirname),
  alias: Object.assign({}, alias,{
    components: 'components/',
    actions: 'components/home',
    store: 'components/common/utility',
    reducers: 'services/textService',
    tests: 'tests/'
  }),
}
  module: {
    loaders: [
    // js
    {
      test: /\.js$/,
      loaders: ['babel'],
      query: {
        presets: ['react', 'es2015', 'stage-1']
      },
      include: path.join(__dirname, 'public')
    },
    // CSS
    {
      test: /\.styl$/,
      include: path.join(__dirname, 'public'),
      loader: 'style-loader!css-loader!stylus-loader'
    }
    ]
  }
};
">>./webpack.config.js

echo -e "const path = require('path');
const express = require('express');
const webpack = require('webpack');
const config = require('./webpack.config.dev');

const port = process.env.PORT || 4000;
const app = express();
const compiler = webpack(config);

app.use(require('webpack-dev-middleware')(compiler, {
  noInfo: true,
  publicPath: config.output.publicPath
}));

app.use(require('webpack-hot-middleware')(compiler));

app.get('*', function(req, res) {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, 'localhost', (err) => {
  if (err) {
    console.log(err);
    return;
  }

  console.log(\`Server has started and is listening on \${port}\`);
});
">>devServer.js


echo -e "{
  \"ecmaFeatures\": {
    \"jsx\": true,
    \"modules\": true
  },
  \"env\": {
    \"browser\": true,
    \"node\": true
  },
  \"parser\": \"babel-eslint\",
  \"rules\": {
    \"quotes\": [2, \"single\"],
    \"strict\": [2, \"never\"],
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
}
">>./.eslintrc

echo -e "import React from 'react';
import ReactDOM from 'react-dom';
import router from 'routes/routes';
import { Route, Router, IndexRoute, hashHistory } from 'react-router';

ReactDOM.render(
    <Application/>,
    document.getElementById('root')
);">>./src/index.js

echo -e "\n\n\t\e[1;32mCompleted Redux setup.\n\n\e[0m"