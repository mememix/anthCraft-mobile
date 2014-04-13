mongoose = require 'mongoose'

WallpaperModel = mongoose.model('wallpaper')
ThemeModel = mongoose.model('theme')
IPLibModel = mongoose.model('IPLib')
DownloadStatisticModel = mongoose.model('DownloadStatistic')
util = require '../../utils'
extendUtil = require '../../utils/extendUtil'
async = require 'async'

module.exports = (app)->

	app.all '*', (req, res, next)->
		# Read statistics data from query string
		# Refresh clientInfo every request
		userIp = req.headers['X-Real-IP'] || req.connection.remoteAddress
		req.session.clientInfo = {} if not req.session.clientInfo
		req.session.clientInfo.serial = req.param('serial') if not req.session.clientInfo.serial

		if not req.session.clientInfo.country
			IPLibModel.getCountry util.dotIp2Num(userIp), (err, result)->
				req.session.clientInfo.userIp = userIp
				req.session.clientInfo.country = result.code
				# Disable log
				# __log "New visitor comes from country[#{req.session.clientInfo.country}] with
				# 	ip[#{req.session.clientInfo.userIp}] and
				# 	IMEI[#{req.session.clientInfo.serial}]. "

				next()
		else
			next()

	app.get '/', (req, res)->
		# Serial(IMEI) comes from the index url called by c-Laucher client
		# req.session.clientInfo.serial = req.param('serial')
		res.redirect '/store'

	# Store index page
	app.get '/store', (req, res, next)->
		page = 1
		pageVolumn = 6
		wallVolum  = 8

		async.parallel {
			themeList: (cb)->
				ThemeModel.listByPage(page, pageVolumn, cb)

			wallpaperList: (cb)->
				WallpaperModel.listByPage(page, wallVolum, cb)

		}, (err, results)->

			return next(err) if err

			res.render 'store/index', {
				themes: results.themeList
				wallpapers: results.wallpaperList
			}


	# Theme detail page
	app.get '/store/theme/:id', (req, res, next)->
		themeId = req.param('id')

		ThemeModel.findById themeId, (err, theme)->
			return next(err) if err

			if not theme?.packageFile?[4]
				return next( new Error('Theme Not Found'))

			res.render 'store/themeDetail', {
				theme: theme
			}

	# Wallpaper detail page
	app.get '/store/wallpaper/:id', (req, res, next)->
		paperId = req.param('id')
		WallpaperModel.findById paperId, (err, wallpaper)->
			return next(err) if err

			res.render 'store/wallpaperDetail', wallpaper

	# Download theme with statistic
	app.get '/store/theme/:id/download', (req, res, next)->
		themeId = req.param('id')
		userEmail = req.user.email
		downloadPath = req.param('path')

		nowDate = new Date()
		dateStr = nowDate.toISOString().substr(0,10)

		statistic = new DownloadStatisticModel(extendUtil({
			userId: req.user.userId
			userEmail: userEmail
			resourceType: 0
			createTime: dateStr
			source: 0
			themeId: themeId
		}, req.session.clientInfo))

		statistic.save (err)->
			__logger.error err if err

			# to the real file url
			res.redirect __config.viewVars.THEME_PATH + downloadPath

	app.get '/store/wallpaper/:id/download', (req, res, next)->
		wpId = req.param('id')
		downloadPath = req.param('path')
		userEmail = req.user.email

		nowDate = new Date()
		dateStr = nowDate.toISOString().substr(0,10)

		statistic = new DownloadStatisticModel(extendUtil({
			userId: req.user.userId
			userEmail: userEmail
			resourceType: 1
			createTime: dateStr
			source: 0
			themeId: wpId #!! actually is wallpaper id here
		}, req.session.clientInfo))

		statistic.save (err)->
			__logger.error err if err

			# to the real file url
			res.redirect __config.viewVars.WALLPAPER_PATH + downloadPath
