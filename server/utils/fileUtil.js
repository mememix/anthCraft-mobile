var fs = require('fs');
var pathSep = require('path').sep;

var Path = require("path");
var directory = module.exports = {};

directory.mkdirSync = function __directory_mkdirSync__(path) {

	var dirs = Path.normalize(path).split(pathSep);
	var root = "";

	while (dirs.length > 0) {
		var dir = dirs.shift();
		if (dir === "") { // If directory starts with a /, the first path will be an empty string.
			root = Path.normalize(pathSep);
		}
		if (!fs.existsSync(root+dir)) {
			fs.mkdirSync(root+dir);
		}
		root += dir + pathSep;
	}
};

directory.mkdir = function __directory_mkdir__(path, callback) {
	var dirs = Path.normalize(path).split(pathSep);
	var root = "";

	mkDir();

	function mkDir() {
		var dir = dirs.shift();
		if (dir === "") { // If directory starts with a /, the first path will be an empty string.
			root = Path.normalize(pathSep);
		}
		fs.exists(root + dir, function (exists) {
			if (!exists) {
				fs.mkdir(root + dir, function (err) {
					root += dir + pathSep;
					if (dirs.length > 0) {
						mkDir();
					} else if (callback) {
						callback();
					}
				});
			} else {
				root += dir + pathSep;
				if (dirs.length > 0) {
					mkDir();
				} else if (callback) {
					callback();
				}
			}
		});
	}
};

// Traverse the folder
// ===================
// @param file {string}
// @param regFilter {RegExp} exclude files
// @param cb {function} (err, file)
directory.traverseFolderSync = function __directory_traverseFolderSync__(file, regFilter, cb) {

	cb = arguments[arguments.length-1];
	if(!file || !fs.existsSync(file)) {
		cb(true);
		return ;
	}

	// Apply filter
	var fileName = Path.basename(file);
	if(regFilter && regFilter.test && regFilter.test(fileName)) {
		return ;
	}

	if(fs.lstatSync(file).isFile()) {
		cb(false, file);
		return ;
	} else if(fs.lstatSync(file).isDirectory()) {
		// is directory
		(fs.readdirSync(file)).forEach(function(item) {
			directory.traverseFolderSync(Path.join(file, item), regFilter, cb);
		});
	}
};
