const path = require('path');
const webpack = require('webpack');

module.exports = {
  devtool: 'source-map',
  entry: [
    'webpack-hot-middleware/client',
    './src/index.js'
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
    })
  },
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