
module.exports = (app)->

	app.get '/user/login3.do', (req, res)->
		# 203  用户名错误（用户名长度不大于100）
		# 204  密码错误（密码长度不大于16）
		# 301  登录失败
		# 303 用户被封禁
		# 100  登录成功
		# return res.end 'error response'

		res.json {
			code: 100
			user: {
				name: 'ijse'
				userId: 1024
				email: 'i@ijser.cn'
			}
		}

	app.get '/user/register2.do', (req, res)->
		# 202 邮箱错误（邮箱长度不大于100）
		# 205 邮箱已经被注册
		# 203 用户名错误（用户名长度不大于30）
		# 206 用户名已经被占用
		# 204 密码错误（密码长度不大于16）
		# 208 注册来源错误（手机浏览器为4）
		# 101 注册失败
		# 100  注册成功

		__debug "Test Register:", req.param('username'), req.param('password')

		res.json {
			code: 100
		}

