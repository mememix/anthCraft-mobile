'use strict';
var mongoose = require('mongoose');
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

exports.dotIp2Num = function dot2num(dot) {
	var ValidIpAddressRegex = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/

	if(!ValidIpAddressRegex.test(dot)) {
		return 0;
	}

    var d = dot.split('.');
    return ((((((+d[0])*256)+(+d[1]))*256)+(+d[2]))*256)+(+d[3]);
}

