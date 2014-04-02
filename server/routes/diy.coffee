module.exports = (app)->

	app.get '/diy', (req, res)->

		# res.end("hello world")
		res.render 'diy', {
			page: "diy page todo"
		}
