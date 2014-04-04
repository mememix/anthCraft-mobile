module.exports = (app)->

	app.get '/design', (req, res)->
		# res.end("hello world")
		res.render 'design/diy', {
			page: "diy page todo"
		}


	app.get '/build', (req, res)->
		# res.end("hello world")
		res.render 'design/buildPackage', {
			page: "diy page todo"
		}

	app.get '/diyicon', (req, res)->
		# res.end("hello world")
		res.render 'design/diyicon', {
			page: "diy page todo"
		}
