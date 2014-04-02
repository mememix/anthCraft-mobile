module.exports = (app)->

	app.get '/login', (req, res)->

		# res.end("hello world")
		res.render 'login', {
			page: "login page todo"
		}
