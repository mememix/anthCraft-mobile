'use strict';
var mongoose = require('mongoose');
var autoinc = require('mongoose-id-autoinc2');
var fileUtil = require('./fileUtil');

exports.loadRoutes = function(routePath, app) {
	fileUtil.traverseFolderSync(routePath, /^[._]/, function(isErr, file) {
		if(isErr) {
			console.log('Error: loading route file ', file);
			throw 'Load routes error!';
		}
		require(file)(app);
	});
};

exports.loadConfigs = function() {
	var configType = process.env.NODE_ENV;
	global.__config = require('../config.' + configType);

	return global.__config;
};

exports.connectDB = function(cb) {
	__log('Connectting MongoDB server...');
	// Connect MongoDB
	mongoose.connect(global.__config.mongo);
	var db = mongoose.connection;

	db.on('error', function(err) {
		cb(err);
	});

	db.once('open', function callback () {
		// yay!
		// Init autoinc module
		autoinc.init(db, 'counter', mongoose);

		__log('MongoDB server connectted!');
		cb();
	});

};
