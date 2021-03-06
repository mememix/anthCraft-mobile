
async = require 'async'
express = require 'express'
mongoose = require 'mongoose'
path = require 'path'
Livereload = require 'connect-livereload'
getMethodOverride = require 'get-methodoverride'
# inherit from express.session.Store
MemcachedStore = require('connect-memcached')(express)
flash = require 'connect-flash'
autoinc = require 'mongoose-id-autoinc2'

anthpack = require 'anthpack'
log4js = require 'log4js'
fileUtil = require './utils/fileUtil'
passportUtil = require './utils/passport'
packageInfo = require '../package.json'

exports.launch = (callback)->
	app = express()

	async.auto {

		load_configs: [ (cb)->
			configType = process.env.NODE_ENV
			global.__config = require('../configs/config.' + configType)
			global.__config.packageInfo = packageInfo
			cb()
		]
		init_logger: [ 'load_configs', (cb)->
			log4js.configure __config.log4js
			global.__logger = log4js.getLogger('master')
			global.__log = -> __logger.info.apply __logger, arguments
			global.__debug = -> __logger.debug.apply __logger, arguments
			cb()
		]
		connect_db: [ 'init_logger', (cb)->
			mongoose.connect __config.mongodb.url
			db = mongoose.connection
			db.on 'error', ()->
				__logger.error 'MongoDB connection error!'

			db.once 'open', ->
				# Init autoinc module
				autoinc.init(db, 'counter', mongoose);

				cb()
		]
		load_models: [ 'connect_db', (cb)->
			fileUtil.traverseFolderSync __config.modelPath, /^[._]/, (isErr, file)->
				if isErr
					__logger.error('Load model file ', file)
					throw 'Load models error!'
				require(file)(app)
			cb()
		]
		init_anthpack: [ 'init_logger', (cb)->
			anthpack.config(__config.anthPack, log4js.getLogger('anthpack'))
			cb()
		]
		init_passport: [ 'init_app', (cb)->
			passportUtil.initPassport()
			cb()
		]
		init_app: [ 'connect_db', (cb)->
			app.set 'port', process.env.PORT or __config.port or 3000
			app.set 'host', process.env.HOST or __config.host or '0.0.0.0'

			# Using behind a reverse proxy
			app.enable('trust proxy')

			# View engine settings
			app.set('view engine', 'ejs')
			app.locals({
				open: "{{"
				close: "}}"
				pretty: true
			})
			app.set('views', __config.viewPath)

			# Set default global view variables
			app.locals(__config.viewVars)

			app.use express.logger('dev') if __config.debug

			app.use express.cookieParser()
			app.use express.bodyParser()
			app.use express.session({
				secret: "anthcraft-mobile"
				# Session keep 1h alive
				cookie: { maxAge: 60 * 60 * 1000 }
				store: new MemcachedStore(__config.memcached)
			})
			app.use express.methodOverride()
			app.use getMethodOverride
			app.use flash()

			# Passport
			passport = passportUtil.passport
			app.use passport.initialize()
			app.use passport.session()

			# Session initialize
			app.use (req, res, next)->
				# Default annoymous user
				req.user = {
					userId: 0
					name: 'Annoymous'
					email: 'null'
				} if not req.user
				# Make session avaliable in all views
				req.session.user = req.user
				res.locals.session = req.session || {}
				next()

			app.use app.router

			# development only
			if __config.debug
				app.use(Livereload({ port: __config.liveReloadPort }))
				app.use(express.static(path.join(__dirname, '../.tmp')))
				app.use(express.static(path.join(__dirname, '../app')))
				app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
			# production or others env
			else
				app.use(express.favicon(path.join(__dirname, '../public/favicon.ico')))
				app.use(express.static(path.join(__dirname, '../public')))

			# 404
			app.use (req, res, next)->
				res.status(404)
				res.render 404, { status: 404, url: req.url }

			# 500, When next(err)...
			app.use (err, req, res, next)->
				__logger.error err
				res.status(500)
				res.render '500', {
					status: err.status or 500
					error: err
				}

			cb()
		]
		load_routes: [ 'load_models', 'init_app', (cb)->

			fileUtil.traverseFolderSync __config.routePath, /^[._]/, (isErr, file)->
				__log 'load route: ', file
				if isErr
					__logger.error('Load route file ', file)
					throw 'Load routes error!'
				require(file)(app, {
					auth: passportUtil.auth
				})

			cb()
		]
	}, (err)->
		callback(err, app)