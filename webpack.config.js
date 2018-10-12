const path = require('path');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var HtmlWebpackInlineSourcePlugin = require('html-webpack-inline-source-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin')


module.exports = {
  entry: './src/index.coffee',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
  },
  devServer: {
    host: '0.0.0.0',
    port: 3000,
    disableHostCheck: true
  },
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js' // 'vue/dist/vue.common.js' for webpack 1
    }
  },
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: ['coffee-loader']
      },
      {
        test: /\.css$/,
        use: [ 'style-loader', 'css-loader' ]
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin(
      {
        template: 'src/index.html',
        inlineSource: '.(js|css)$'
      }
    ),
    new HtmlWebpackInlineSourcePlugin(),
    new CopyWebpackPlugin([
      { from: 'src/extension.json', to: '' }
    ])
  ]
};