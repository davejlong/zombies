const path = require('path');

const config = {
  entry: './frontend/js/index.js',
  output: {
    path: path.resolve(__dirname, 'priv/static/app'),
    filename: 'app.js'
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          loaders: {
            js: 'babel-loader?presets[]=es2015'
          }
        }
      },
      {
        test: /\.js$/,
        exclude: [/node_modules/],
        use: [{
          loader: 'babel-loader',
          options: { presets: ['es2015'] },
        }],
      },
      {
        test: /\.(json|png)$/,
        use: 'file-loader?name=[name].[ext]'
      },
      {
        test: /\.css$/,
        use: [ 'style-loader', 'css-loader' ]
      }
    ]
  },
  devServer: {
    contentBase: path.join(__dirname, "priv/static"),
    host: "0.0.0.0",
    hot: true,
    inline: true,
    stats: "errors-only"
  }
};

module.exports = config;
