passport = require 'passport'

module.exports = (app)->

	app.get '/login', (req, res)->

		# Restore username from cookies
		username = req.cookies.username || 'tester'

		# res.end("hello world")
		res.render 'login', {
			message: req.flash('message')
			username: username
		}

	app.post '/login', (req, res, next)->
		username = req.param('username')
		remember = req.param('remember')
		res.cookie 'username', username, {
			# domain: '.c-launcher.com',
			path: '/',
			# Keep 30 days
			maxAge: 1000*60*60*24*30
		} if remember

		next()
	, passport.authenticate 'local', {
		successRedirect: '/',
		failureRedirect: '/login'
		failureFlash: true
	}

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

