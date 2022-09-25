const baseConfig = require('./_base.js');
const { merge } = require('webpack-merge');

module.exports = merge(baseConfig, {
    mode: 'production',
    output: {
        publicPath: '/'
    },
});
