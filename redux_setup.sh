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


sudo npm install --save autoprefixer-loader sass-loader style-loader css-loader node-sass extract-text-webpack-plugin

sudo npm install --save-dev lodash
sudo npm install --save-dev classnames

sudo npm install --save-dev webpack webpack-dev-middleware webpack-hot-middleware


mkdir -p ./src/{store,actions,router,reducers,components}

echo -e "/**
  Action Creators

  These fire events which the reducer will handle
  We will later call these functions from inside our component

  Later these functions get bound to 'dispatch' fires the actual event
  Right now they just return an object

  It's a code convention to use all capitals and snake case for the event names
  We use const to store the name of the event so it is immutable

*/

export function increment(i) {
  return {
    type: 'INCREMENT_LIKES',
    index: i
  };
}

/*
  Comments
*/

export function addComment(postId, author, comment) {
  return {
    type: 'ADD_COMMENT',
    postId,
    author, // same as author: author
    comment // same as comment: comment
  };
}

export function removeComment(postId, i){
  return {
    type: 'REMOVE_COMMENT',
    i,
    postId
  };
}
">>./src/actions/actionCreators.jsx

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
import BooksReducer from './reducer_books';
import ActiveBook from './reducer_active_book';

const rootReducer = combineReducers({
  books: BooksReducer,
  activeBook: ActiveBook
});

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
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import { Provider } from 'react-redux';
import store, { history } from './store';

const Routes = (
  <Provider store={store}>
    <Router history={history}>
      <Route path=\"/\" component={App}>
        <IndexRoute component={PhotoGrid} />
        <Route path=\"/view/:postId\" component={Single} />
      </Route>
    </Router>
  </Provider>
);
export default Routes;
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
    filename: 'app.js',
    publicPath: '/public/'
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
  resolve: {
    alias: {
      components: path.resolve(__dirname, 'src/components/'),
      reducers: path.resolve(__dirname, 'src/reducers/'),
    },
    extensions: ['*', '.js', '.jsx']
  },
  devServer: {
    contentBase: './public'
  },
  module: {
    loaders: [
    // js
    {
      test: /\.js$/,
      loaders: ['babel-loader'],
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
">>./webpack.config.dev.js

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
import { render } from 'react-dom';
import Routes from 'routes/routes';

render(
    <Routes/>,
    document.getElementById('root')
);">>./src/index.js

echo -e "\n\n\t\e[1;32mCompleted Redux setup.\n\n\e[0m"