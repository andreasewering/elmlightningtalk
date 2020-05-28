const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const TerserPlugin = require("terser-webpack-plugin");

module.exports = {
  entry: "./index.js",
  mode: "production",
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "elm-webpack-loader",
          options: {
            optimize: true,
          },
        },
      },
      {
        test: /\.css$/i,
        exclude: [/elm-stuff/, /node_modules/],
        use: ["style-loader", "css-loader"],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      favicon: "public/favicon.ico",
    }),
  ],
  optimization: {
    minimize: true,
    minimizer: [new TerserPlugin({ terserOptions: { topLevel: true } })],
  },
  output: {
    filename: "main.js",
    path: path.join(__dirname, "dist"),
  },
  devServer: {
    contentBase: path.join(__dirname, "dist"),
    compress: true,
    port: 9000,
    historyApiFallback: true,
  },
};
