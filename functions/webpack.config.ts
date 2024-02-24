import { Configuration } from "webpack";
import path from "path";
import fs from "fs";
import ZipPlugin from "zip-webpack-plugin";

const srcDir = path.join(__dirname, "src");

const srcFiles = fs
  .readdirSync(srcDir)
  .filter((file) => /\.ts/.test(file))
  .reduce((a, b) => {
    a[b.replace(/\.ts$/, "")] = path.join(srcDir, b);
    return a;
  }, {} as Record<string, string>);

const config: Configuration = {
  mode: "production",
  entry: srcFiles,
  output: {
    path: path.join(__dirname, "dist"),
    libraryTarget: "commonjs2",
  },
  target: "node20",
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: "swc-loader",
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: [".ts", ".js"],
  },
  externals: {
    "@aws-sdk/client-s3": "commonjs2 @aws-sdk/client-s3",
    "@aws-sdk/client-dynamodb": "commonjs2 @aws-sdk/client-dynamodb",
  },
  devtool: "source-map",
  plugins: [
    ...Object.keys(srcFiles).map(
      (name) =>
        new ZipPlugin({
          filename: `${name}.zip`,
          include: [`${name}.js`, `${name}.js.map`],
        })
    ),
  ],
};

export default config;
