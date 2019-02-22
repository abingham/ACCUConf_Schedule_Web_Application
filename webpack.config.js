var CopyPlugin = require( 'copy-webpack-plugin' );
require('dotenv').config();
var path = require("path");
var webpack = require("webpack");

module.exports = {
  // TODO: Can we set this in .env or something?
  mode: 'development',

  entry: {
    app: [
      './src/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
  },

  module: {
    rules:[
      {
        test: /\.(css|scss)$/,
        use: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.html$/,
        // exclude: /node_modules/,
        use: {
            loader: 'html-loader',
            options: {}
          }
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: {}
        }
      },
      // {
      //   test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      //   use: 'url-loader?limit=10000&mimetype=application/font-woff'
      // },
      // {
      //   test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      //   use: 'file-loader'
      // },
    ]
  },
  plugins: [
      new CopyPlugin([
          {
              from: 'src/static/img/',
              to:   'static/img/'
          },
      ]),
      new webpack.EnvironmentPlugin(["API_BASE_URL"])
  ],

  devServer: {
    inline: true,
    stats: { colors: true }
  },

  node: {
    // console: 'empty',
    fs: 'empty',
    net: 'empty',
    tls: 'empty'
    // console: false,
    // global: true,
    // process: true,
    // Buffer: true,
    // __filename: "mock",
    // __dirname: "mock",
    // setImmediate: true
  }
};
