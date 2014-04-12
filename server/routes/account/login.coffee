passport = require 'passport'

module.exports = (app)->


	# 203  用户名错误（用户名长度不大于100）
	# 204  密码错误（密码长度不大于16）
	# 301  登录失败
	# 303 用户被封禁
	# 100  登录成功
	#
	lang = {
		'203': 'User Name is incorect',
		'204': 'Password  is incorect',
		'301': 'login faild',
		'303': 'User was blocked'
	}

	app.get '/login', (req, res)->

		# Restore username from cookies
		username = req.cookies.username || ''

		res.render 'login', {
			message:  lang[req.flash('error')]
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
