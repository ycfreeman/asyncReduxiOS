var path = require('path')
var webpack = require('webpack')

module.exports = {
  devtool: 'cheap-module-eval-source-map',
  entry: {
    // '/':[
    //   'webpack-hot-middleware/client',
    //   './index'
    // ],
    'iosReduxAsync/iosReduxAsync/js': './index',
    'dist':'./index'
  },
  output: {
    path: path.join(__dirname, '/'),
    filename: '[name]/app.js',
    // publicPath: '/static/'
  },
  // plugins: [
  //   new webpack.optimize.OccurenceOrderPlugin(),
  //   new webpack.HotModuleReplacementPlugin()
  // ],
  module: {
    loaders: [
      {
        test: /\.js$/,
        loaders: ['babel'],
        exclude: /node_modules/,
        include: __dirname
      }
    ]
  }
}
