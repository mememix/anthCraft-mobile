http = require 'http'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
extendUtil = require './extendUtil'
queryString = require 'querystring'
crypto = require 'crypto'

# aes(md5(password))
encryptPassword = (str, key)->
	cipher = crypto.createCipher('aes-128-ecb', key)
	str_md5 = crypto.createHash('md5').update(str).digest('hex')
	cipher.update(str_md5, 'utf8', 'hex') + cipher.final('hex')

exports.initPassport = ->

	passport.serializeUser (user, done)->
		done(null, user)

	passport.deserializeUser (user, done)->
		done(null, user)

	passport.use(new LocalStrategy(
		(username, password, done)->

			# http://themes.c-launcher.com/user/login3.do?username=chenhua&password=asdf1234(正式路径)
			# http://test.themes.c-launcher.com/user/login3.do?username=chenhua&password=asdf1234(测试路径)
			# http://10.12.0.71:8080/shop/user/login3.do?username=chenhua&password=asdf1234(本地访问)
			# {"code":100}
			# 返回值：
			# 203  用户名错误（用户名长度不大于100）
			# 204  密码错误（密码长度不大于16）
			# 301  登录失败
			# 303 用户被封禁
			# 100  登录成功

			# encrypt password with md5 and aes
			password_enc = encryptPassword(password, __config.apiService.account.login_aesKey)

			# Deep copy from configs
			reqOpts = extendUtil {}, __config.apiService.account.validateUser

			# Append params
			reqOpts.path += '?' + queryString.stringify {
				username: username
				password: password_enc
			}

			# Send http request to remote server
			__debug 'Validate user login request: ', reqOpts
			http.request reqOpts, (res)->

				res.on 'error', (err)->
					done err, false

				res.on 'data', (data)->
					__debug 'Validate user login response: ', data.toString()
					try
						data = JSON.parse(data)
						if data.code is 100
							done null, data.user
						else
							done null, false, {
								code: data.code
								message: 'Validate fail.'
							}
					catch e
						# throw new Error('Server error!')
						done new Error(e)

			.end()

		)
	)

# Send register request to remote server
exports.register = (user, done)->
	# http://themes.c-launcher.com/user/register2.do?email=&username=&password=&source=4(正式路径)
	# http://test.themes.c-launcher.com/user/register2.do?email=&username=&password=&source=4(测试路径)
	# http://10.12.0.71:8080/shop/user/register2.do?email=&username=&password=&source=4(本地访问)
	# {"code":100}
	# 返回值：
	# 202 邮箱错误（邮箱长度不大于100）
	# 205 邮箱已经被注册
	# 203 用户名错误（用户名长度不大于30）
	# 206 用户名已经被占用
	# 204 密码错误（密码长度不大于16）
	# 208 注册来源错误（手机浏览器为4）
	# 101 注册失败
	# 100  注册成功

	# encrypt password with md5 and aes
	password_enc = encryptPassword(password, __config.apiService.account.register_aesKey)

	reqOpts = extendUtil {}, __config.apiService.account.registerUser
	# Append params
	reqOpts.path += '?' + queryString.stringify {
		source: 4
		username: user.username
		password: password_enc
		email: user.email
	}

	__debug 'Validate user register request: ', reqOpts
	r = http.request reqOpts, (res)->
		res.on 'error', (err)->
			done err

		res.on 'data', (data)->
			__debug 'Validate user register response: ', data.toString()
			try
				data = JSON.parse(data)
				done null, data
			catch e
				done e
	r.end()


# Authority middleware
exports.auth = (req, res, next)->
	return next() if req.user

	# if req.is('json')
	# 	return res.json 203, {
	# 		login: '/login'
	# 	}
	# res.redirect('/login')

	# ALLOW annoymous package theme
	req.user = {
		userId: 0
		name: 'Annoymous'
	}
	next()

	return

exports.passport = passport
