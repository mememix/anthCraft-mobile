
path = require 'path'
basePath = path.join(__dirname, '..')

module.exports = {
	debug: true
	port: 9523
	liveReloadPort: 35729
	host: '0.0.0.0'

	routePath: "#{basePath}/server/routes"
	viewPath: "#{basePath}/views"
}