module.exports = (app)->

	app.get '/themeDetail', (req, res)->

		res.render 'themeDetail', {
			theme: {
				id: '123'
				title: 'Just for you'
				size: '17.3'
				src: '/styles/image/default.png'
			}
		}
