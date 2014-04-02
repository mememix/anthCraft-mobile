module.exports = (app)->

	app.get '/', (req, res)->

		# res.end("hello world")
		res.render 'index', {
			appName: "anthCraft Mobile"
		}
