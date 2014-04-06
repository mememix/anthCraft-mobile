anthpack = require 'anthpack'

module.exports = (app)->

	# Generate preview images
	app.post '/design/theme/:themeId/preview', __auth, (req, res, next)->
		themeId = req.param('themeId')
		packData = req.body

		res.end 'todo: return preview images'

	app.post '/design/theme/:themeId/package', __auth, (req, res, next)->
		themeId = req.param('themeId')
		packData = req.body

		res.end 'todo: return package files'

	app.post '/design/theme/:themeId/upload/wallpaper', __auth, (req, res, next)->
		themeId = req.param('themeId')
		wpFile = req.files.wpFile

		anthpack.format
		res.end 'todo: upload images'


	app.put '/design/theme/:themeId/chose/wallpaper/:wpId', __auth, (req, res, next)->
		themeId = req.param('themeId')

		# Chose or upload wallpaper
		wpId = req.param('wpId')
		res.end 'todo: chose wallpaper'

	app.put '/design/theme/:themeId/chose/iconset/:iconSet', __auth, (req, res, next)->
		themeId = req.param('themeId')

		iconsetId = req.param('iconSet')

		res.end 'todo: chose iconset'