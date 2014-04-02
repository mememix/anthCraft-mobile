
async = require 'async'
express = require 'express'
path = require 'path'
Livereload = require 'connect-livereload'

exports.launch = (callback)->
	app = express()

	async.auto {

		load_configs: [ (cb)->
			configType = process.env.NODE_ENV
			global.__config = require('../configs/config.' + configType)

			cb()
		]
		init_logger: [ 'load_configs', (cb)->
			cb()
		]
		connect_db: [ 'init_logger', (cb)->
			cb()
		]
		load_models: [ 'connect_db', (cb)->
			cb()
		]
		init_app: [ 'connect_db', (cb)->
			app.set 'port', process.env.PORT or __config.port or 3000
			app.set 'host', process.env.HOST or __config.host or '0.0.0.0'

			app.use express.logger('dev') if __config.debug

			app.use express.cookieParser()
			app.use express.cookieSession({
				secret: "anthcraft-mobile"
			})

			app.use express.bodyParser()
			app.use express.methodOverride()
			app.use app.router

			# development only
			if __config.debug
				app.use(Livereload({port: __config.liveReloadPort }))
				app.use(express.static(path.join(__dirname, '../.tmp')))
				app.use(express.static(path.join(__dirname, '../app')))
				app.use(express.errorHandler())
			# production or others env
			else
				app.use(express.favicon(path.join(__dirname, '../public/favicon.ico')))
				app.use(express.static(path.join(__dirname, '../public')))

			cb()
		]
		load_routes: [ 'init_app', (cb)->
			cb()
		]
	}, (err)->
		callback(err, app)