mongoose = require 'mongoose'

WallpaperModel = mongoose.model('wallpaper')
ThemeModel = mongoose.model('theme')
async = require 'async'

module.exports = (app)->

	app.get '/', (req, res)->
		res.redirect '/store'

	app.get '/store', (req, res)->
		PAGE_COUNT = 5
		page = 1
		pageVolumn = 6

		async.parallel {
			themeList: (cb)->
				ThemeModel.listByPage(page, pageVolumn, cb)

			wallpaperList: (cb)->
				WallpaperModel.listByPage(page, pageVolumn, cb)

		}, (err, results)->

			return next(err) if err

			res.render 'index', {
				themes: results.themeList
				wallpapers: results.wallpaperList
			}

	app.get '/store/more/theme?page=:page', (req, res)->
		page = req.param('page')
		pageVolumn = 6
		ThemeModel.listByPage page, pageVolumn, (err, list)->
			return next(err) if err

			res.json list

	app.get '/store/more/wallpaper?page=:page', (req, res)->
		page = req.param('page')
		pageVolumn = 6
		WallpaperModel.listByPage page, pageVolumn, (err, list)->
			return next(err) if err

			res.json list

