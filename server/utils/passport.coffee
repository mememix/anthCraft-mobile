
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

exports.initPassport = ->

	testUser = {
		userId: 1024
		username: 'tester'
		password: 'mypassword'
	}

	passport.serializeUser (user, done)->
		__log "serializeUser", arguments
		done(null, user)

	passport.deserializeUser (user, done)->
		# __log "deserializeUser", arguments
		done(null, user)

	passport.use(new LocalStrategy(
		(username, password, done)->

			# Validate info
			if username is 'tester' and password is 'mypassword'
				done null, testUser
			else
				done null, false, { message: 'Incorrect username or password' }

		)
	)


# Authority middleware
exports.auth = (req, res, next)->
	return next() if req.user

	if req.is('json')
		return res.json 203, {
			login: '/login'
		}
	res.redirect('/login')

	return

exports.passport = passport
