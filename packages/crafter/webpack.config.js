const path = require("path");
const webpack = require("webpack");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CopyPlugin = require("copy-webpack-plugin");
const ReactRefreshWebpackPlugin = require("@pmmmwh/react-refresh-webpack-plugin");
const tailwindcss = require("tailwindcss");
const MonacoWebpackPlugin = require("monaco-editor-webpack-plugin");
const NodePolyfillPlugin = require("node-polyfill-webpack-plugin");
const getTailwindConfig = require("../../tailwindMain.config");

module.exports = {
  mode: "development",
  entry: {
    app: "./test/CF_Test.bs.js",
  },
  output: {
    path: path.resolve(__dirname, "dist"),
    clean: true,
    publicPath: "/",
  },
  devServer: {
    allowedHosts: [".juspay.net"],
    static: {
      directory: path.resolve(__dirname, "dist"),
    },
    port: 8000,
    hot: true,
  },
  module: {
    rules: [
      // {
      //   test: /\.css$/i,
      //   include: [
      //     path.resolve(__dirname, "src/styles/_main.css"),
      //     path.resolve(__dirname, "src/styles/_hljs.css"),
      //   ],
      //   use: [
      //     MiniCssExtractPlugin.loader,
      //     "style-loader",
      //     "css-loader",
      //     "postcss-loader",
      //   ],
      // },
      {
        test: /\.css$/i,
        // exclude: path.resolve(__dirname, "test/_hljs.css"),
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          {
            loader: "postcss-loader",
            options: {
              postcssOptions: {
                plugins: [[tailwindcss(getTailwindConfig("switchboard"))]],
              },
            },
          },
        ],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin(),
    new CopyPlugin({
      patterns: [{ from: "test/index.html", to: "index.html" }].filter(Boolean),
    }),
    new MonacoWebpackPlugin(),
    new NodePolyfillPlugin(),
  ].filter(Boolean),
};
