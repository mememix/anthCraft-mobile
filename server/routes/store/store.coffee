mongoose = require 'mongoose'

WallpaperModel = mongoose.model('wallpaper')
ThemeModel = mongoose.model('theme')
DownloadStatisticModel = mongoose.model('DownloadStatistic')
extendUtil = require '../../utils/extendUtil'
async = require 'async'

module.exports = (app)->

	app.get '/', (req, res)->
		res.redirect '/store'

	# Store index page
	app.get '/store', (req, res, next)->
		page = 1
		pageVolumn = 6

		async.parallel {
			themeList: (cb)->
				ThemeModel.listByPage(page, pageVolumn, cb)

			wallpaperList: (cb)->
				WallpaperModel.listByPage(page, pageVolumn, cb)

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

			if theme?.packageFile?[4]
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
			__debug err if err

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
			__debug err if err

			# to the real file url
			res.redirect __config.viewVars.WALLPAPER_PATH + downloadPath
