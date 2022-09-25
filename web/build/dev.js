const baseConfig = require('./_base.js');
const { merge } = require('webpack-merge');

module.exports = merge(baseConfig, {
    mode: 'development',
    devServer: {
        historyApiFallback: {
          disableDotRule: true
        },
        open: true,
        liveReload: true,
        hot: false,
        watchFiles: ["data/**"]
    },
    devtool: 'source-map',
    output: {
        publicPath: '/'
    },
});
