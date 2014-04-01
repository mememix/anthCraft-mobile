
require('coffee-script/register');

var http = require('http'),
	server = require('./server');

server.launch(function(err, app) {

	http.createServer(app).listen(app.get('port'), app.get('host'), function () {
		console.log('Server listening on port %d in %s mode', app.get('port'), app.get('env'));
	});

});


