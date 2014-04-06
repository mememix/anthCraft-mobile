passport = require '../../utils/passport'
module.exports = (app)->

	app.get '/register', (req, res)->

		res.render 'register', {
			code: req.flash('code')
			message: req.flash('message')
		}

	app.post '/register', (req, res, next)->
		user = {
			email: req.param('email')
			username: req.param('username')
			password: req.param('password')
		}
		password2 = req.param('password2')

		if user.password isnt password2
			req.flash 'message', 'Wrong password2'
			res.redirect '/register'
			return

		# Register user through remote server
		passport.register user, (err, result)->
			return next(err) if err

			if result.code is 100
				res.redirect '/login'
			else
				req.flash 'code', result.code
				res.redirect '/register'

