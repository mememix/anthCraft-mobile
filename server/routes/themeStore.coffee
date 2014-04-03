module.exports = (app)->

	app.get '/store/theme', (req, res)->

		# res.end("hello world")
		res.render 'themeStore', {
			theme: {
				id: '123'
				title: 'Just for you'
				charge: '0'
				src: '/styles/image/default.png'
			}
		}
