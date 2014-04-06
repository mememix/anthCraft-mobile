mongoose = require 'mongoose'

WallpaperModel = mongoose.model('wallpaper')
ThemeModel = mongoose.model('theme')
async = require 'async'

module.exports = (app)->

	app.get '/', (req, res)->
		PAGE_COUNT = 5

		async.parallel {
			themeList: (cb)->
				page = 1
				pageVolumn = 6
				ThemeModel.listByPage(page, pageVolumn, cb)

			wallpaperList: (cb)->
				WallpaperModel
					.find({
						status: 2
					})
					.skip(0)
					.limit(PAGE_COUNT)
					.sort('-updateTime')
					.exec cb

		}, (err, results)->

			return next(err) if err

			res.render 'index', {
				themes: results.themeList
				wallpapers: results.wallpaperList
			}

	app.get '/more/theme?page=:page', (req, res)->
		page = req.param('page')
		pageVolumn = 6
		ThemeModel.listByPage page, pageVolumn, (err, list)->
			return next(err) if err

			res.json list

	app.get '/more/wallpaper?page=:page', (req, res)->
		page = req.param('page')
		pageVolumn = 6
		WallpaperModel.listByPage page, pageVolumn, (err, list)->
			return next(err) if err

			res.json list

