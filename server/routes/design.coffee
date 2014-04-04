module.exports = (app)->

	app.get '/design(/wallpaper)?', (req, res)->
		# res.end("hello world")
		res.render 'design/diywallpaper', {
			page: "diy page todo"
		}

	app.get '/design/package', (req, res)->
		# res.end("hello world")
		res.render 'design/package', {
			page: "diy page todo"
		}

	app.get '/design/iconset', (req, res)->
		# res.end("hello world")
		res.render 'design/diyiconset', {
			page: "diy page todo"
		}
