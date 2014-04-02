module.exports = (app)->

	app.get '/store/wallpaper', (req, res)->

		# res.end("hello world")
		res.render 'wallpaperStore', {
			page: "theme store page todo"
		}
