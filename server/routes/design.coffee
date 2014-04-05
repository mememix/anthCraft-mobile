module.exports = (app)->

	app.get '/design', (req, res)->
		# res.end("hello world")
		res.render 'design/index', {
			page: "diy page todo"
		}
