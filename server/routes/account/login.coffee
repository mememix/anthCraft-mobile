passport = require 'passport'

module.exports = (app)->

	app.get '/login', (req, res)->

		# Restore username from cookies
		username = req.cookies.username || 'tester'

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

		# next()
		
	, passport.authenticate 'local', {
		successRedirect: '/',
		failureRedirect: '/login'
		failureFlash: true
	}
