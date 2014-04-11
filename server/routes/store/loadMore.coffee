mongoose = require 'mongoose'

WallpaperModel = mongoose.model('wallpaper')
ThemeModel = mongoose.model('theme')

module.exports = (app)->

	# Load more data
	app.get '/store/more/theme', (req, res)->
		page = req.param('page') || 1
		pageVolumn = 6
		ThemeModel.listByPage page, pageVolumn, (err, list)->
			return next(err) if err

			#res.json list
			res.render 'store/moreTheme', {
				themes: list
				next_page: ++page
			}

	app.get '/store/more/wallpaper', (req, res)->
		page = req.param('page')
		pageVolumn = 8
		WallpaperModel.listByPage page, pageVolumn, (err, list)->
			return next(err) if err

			#res.json list
			res.render 'store/moreWallpaper', {
				wallpapers: list
				next_page: ++page
			}
