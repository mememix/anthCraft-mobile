module.exports = (app)->

	app.get '/diy', (req, res)->
		# res.end("hello world")
		res.render 'diy', {
			page: "diy page todo"
		}


	app.get '/build', (req, res)->
		# res.end("hello world")
		res.render 'buildPackage', {
			page: "diy page todo"
		}

	app.get '/diyicon', (req, res)->
		# res.end("hello world")
		res.render 'diyicon', {
			page: "diy page todo"
		}
