const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
// const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { VueLoaderPlugin } = require('vue-loader')

const path = require('path')
const resolve = (dir) => path.join(__dirname, '..', dir)

module.exports = {
    entry: {
        code: './src/main.js',
    },
    output: {
        filename: 'code.[fullhash].js',
    },
    module: {
        rules: [{
            test: /\.css$/i,
            use: ['style-loader', 'css-loader'],
        }, {
            test: /\.scss$/i,
            use: ['style-loader', 'css-loader', "sass-loader"],
        }, {
            test: /\.vue$/i,
            use: 'vue-loader'
        }]
    },
    resolve: {
        alias: {
            '@': resolve('src'),
        },
    },
    plugins: [
        new CopyWebpackPlugin({
            patterns: [
                { from: 'data', to: 'data' }
            ]
        }),
        new HtmlWebpackPlugin({
            template: 'index.html',
            favicon: 'assets/icon.png',
        }),
        new VueLoaderPlugin(),

        // new MiniCssExtractPlugin({
        //     filename: 'style.[fullhash].css'
        // })
    ]
};
