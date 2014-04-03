
path = require 'path'
basePath = path.join(__dirname, '..')

module.exports = {
	debug: true
	port: 9523
	liveReloadPort: 35729
	host: '0.0.0.0'

	resourcePath: "e:/worktop/anthCraft/app/resources"

	routePath: "#{basePath}/server/routes"
	viewPath: "#{basePath}/views"

	mongodb: {
		url: "mongodb://admin:123@10.127.129.88:27017/anthcraft"
	}

	log4js: {
		appenders: [
			{ type: "console" }
			{
				type: 'file'
				filename: "#{basePath}/logs/anthpack.log"
				maxLogSize: 204800
				backups: 3
				category: "anthpack"
			}
			{
				type: 'file'
				filename: "#{basePath}/logs/master.log"
				maxLogSize: 204800
				backups: 3
				category: "master"
			}
		],
		replaceConsole: true
	}
}