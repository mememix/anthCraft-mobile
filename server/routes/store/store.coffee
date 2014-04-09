mongoose = require 'mongoose'

WallpaperModel = mongoose.model('wallpaper')
ThemeModel = mongoose.model('theme')
async = require 'async'

module.exports = (app)->

	app.get '/', (req, res)->
		res.redirect '/store'

	# Store index page
	app.get '/store', (req, res, next)->
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

			res.render 'store/index', {
				themes: results.themeList
				wallpapers: results.wallpaperList
			}


	# Theme detail page
	app.get '/store/theme/:id', (req, res, next)->
		themeId = req.param('id')
		ThemeModel.findById themeId, (err, theme)->
			return next(err) if err

			res.render 'store/themeDetail', {
				theme: theme
				screens:[
					{
						src:"/images/detail.jpg"
					}
					{
						src:"/images/detail.jpg"
					}
					{
						src:"/images/detail.jpg"
					}
					{
						src:"/images/detail.jpg"
					}
					{
						src:"/images/detail.jpg"
					}
				]
			}

	# Wallpaper detail page
	app.get '/store/wallpaper/:id', (req, res, next)->
		paperId = req.param('id')
		WallpaperModel.findById paperId, (err, wallpaper)->
			return next(err) if err

			res.render 'store/wallpaperDetail', wallpaper

	# Download theme with statistic
	app.get '/store/theme/:id/download', (req, res, next)->

		res.end 'todo: statistic and download file'
