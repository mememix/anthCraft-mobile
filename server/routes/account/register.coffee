passport = require '../../utils/passport'
module.exports = (app)->

	# 返回值：
	# 202 邮箱错误（邮箱长度不大于100）
	# 205 邮箱已经被注册
	# 203 用户名错误（用户名长度不大于30）
	# 206 用户名已经被占用
	# 204 密码错误（密码长度不大于16）
	# 208 注册来源错误（手机浏览器为4）
	# 101 注册失败
	# 100  注册成功
	#
	lang = {
		'202': 'Mail length should not beyond 100',
		'205': 'The mail account is already registed',
		'203': 'User name shoud not beyond 30',
		'206': 'The user name is in use',
		'204': 'Password shoud not beyond 16',
		'208': 'The origin of regist is wrong',
		'4': 'The origin of regist is wrong',
		'101': 'Regist failed',
		'100': 'Success',
	}
	
	app.get '/register', (req, res)->

		res.render 'register', {
			message: lang[req.flash('code')] || ''
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
			# res.redirect '/register'
			return

		# Register user through remote server
		passport.register user, (err, result)->
			return next(err) if err
			req.flash 'code', result.code
			result.msg = lang[result.code]
			res.json result

