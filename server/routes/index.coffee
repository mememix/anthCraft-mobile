WallpaperModel = require '../models/Wallpaper'

module.exports = (app)->

	app.get '/', (req, res)->

		WallpaperModel.find {}, (err, list)->

			res.render 'index', {
				appName: "anthCraft Mobile"
				wallpapers: list
				theme: {
					id: '123'
					title: 'Just for you'
					charge: '0'
					src: '/styles/image/default.png'
				}
			}
