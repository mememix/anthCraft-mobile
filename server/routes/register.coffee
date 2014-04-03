module.exports = (app)->

	app.get '/regist', (req, res)->

		# res.end("hello world")
		res.render 'register', {
			page: "login page todo"
		}

	app.get '/packageFailed', (req, res)->

		# res.end("hello world")
		res.render 'packageFailed', {
			page: "login page todo"
		}


	app.get '/packageSuccess', (req, res)->

		# res.end("hello world")
		res.render 'packageSuccess', {
			page: "login page todo"
		}
