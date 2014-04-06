module.exports = (app)->


	app.get '/register', (req, res)->

		res.render 'register', {
			message: req.flash('message')
		}

	app.post '/register', (req, res)->
		user = {
			email: req.param('email')
			username: req.param('username')
			password: req.param('password')
		}
		password2 = req.param('password2')

		__debug user, password2

		if user.password isnt password2
			req.flash 'message', 'Wrong password2'
			res.redirect '/register'
			return

		#TODO: register user

		res.redirect '/login'

