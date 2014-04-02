WallpaperModel = require '../models/Wallpaper'

module.exports = (app)->

	app.get '/', (req, res)->

		WallpaperModel.find {}, (err, list)->

			res.render 'index', {
				appName: "anthCraft Mobile"
				wallpapers: list
			}
