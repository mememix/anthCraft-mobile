module.exports = (app)->

	app.get '/regist', (req, res)->

		# res.end("hello world")
		res.render 'register', {
			page: "login page todo"
		}
