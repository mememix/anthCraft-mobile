mongoose = require 'mongoose'
WallpaperModel = mongoose.model 'wallpaper'
IconSetModel = mongoose.model 'IconGroups'
async = require 'async'

module.exports = (app)->

	# design/index page, aka wallpaper diy page
	app.get '/design', (req, res)->
		page = 1
		pageVolumn = 6

		async.parallel {
			wallpaperList: (cb)->
				WallpaperModel.listByPage(page, pageVolumn, cb)

			iconSets: (cb)->
				IconSetModel.listByPage(page, pageVolumn, cb)
		}, (err, result)->

			return next(err) if err

			res.render 'design/index', {
				wallpapers: result.wallpaperList
				iconSets: result.iconSets
			}

