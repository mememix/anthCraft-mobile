module.exports = (app)->

	app.get '/store/theme', (req, res)->

		# res.end("hello world")
		res.render 'themeStore', {
			page: "theme store page todo"
		}
