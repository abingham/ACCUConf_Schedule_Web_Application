var CopyPlugin = require( 'copy-webpack-plugin' );
const HTMLWebpackPlugin = require("html-webpack-plugin");
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
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: {}
        }
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: {
          loader: 'url-loader',
          options: {
            limit: 10000,
            mimetype: 'application/font-woff'
          }
        }
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: {
          loader: 'file-loader',
          options: {}
        }
      },
    ]
  },
  plugins: [
      new CopyPlugin([
          {
              from: 'src/static/img/',
              to:   'static/img/'
          },
      ]),
      new HTMLWebpackPlugin({
        // Use this template to get basic responsive meta tags
        template: "src/index.html",
        // inject details of output file at end of body
        inject: "body"
      }),
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
