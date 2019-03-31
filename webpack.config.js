const webpack = require('webpack');
const path = require('path');

module.exports = {
	context: path.resolve(__dirname, './assets/js/src'),
	entry: {
		app_main:'./app_main.js',
		app_config:'./app_config.js',
		app_sm_list:'./app_sm_list.js',
		app_sm_page:'./app_sm_page.js',
		app_sm_new_page:'./app_sm_new_page.js',
	},
	output: {
		path: path.resolve(__dirname, 'assets/js'),
		filename: "[name].js"
	},
	mode: 'production',
	resolve: {
		alias: {
			// jquery: "jquery/src/jquery",
			'vue$': 'vue/dist/vue.esm.js' // 'vue/dist/vue.common.js' for webpack 1
		}
	},
	plugins: [
		new webpack.ProvidePlugin({
			$: "jquery",
			jQuery: "jquery"
		})
	],
	module: {
		rules: [
		//{
		//	//test: require.resolve("some-module"),
		//	test: require.resolve("./node_modules/slider-pro/dist/js/jquery.sliderPro.js"),
		//	use: "imports-loader?$=jquery"
		//},
		//{
		//	test: /\.css$/,
		//	use: [
		//		'style-loader',
		//		'css-loader'
		//	]
		//}
		]
	}
};

