anthpack = require 'anthpack'
fs = require 'fs'
path = require 'path'

module.exports = (app)->

	# Generate preview images
	app.post '/design/theme/:themeId/preview', __auth, (req, res, next)->
		themeId = req.param('themeId')
		packData = req.session.packData
		packData.themeId = themeId

		# Generate preview images and theme thumbnail
		anthpack.preview packInfo, (err, previews, thumbnail)->
			return next(err) if err
			res.json {
				previewList: previews
				thumbnail: thumbnail
			}

	app.post '/design/theme/:themeId/package', __auth, (req, res, next)->
		themeId = req.param('themeId')
		packData = req.body

		res.end 'todo: return package files'

	app.post '/design/theme/:themeId/upload/wallpaper', __auth, (req, res, next)->
		themeId = req.param('themeId')

		imgPath = req.files.wpFile

		anthPack.format {
			themeId: themeId
			type: 'wallpaper'
			name: 'wallpaper'
			file: imgPath
			scale: {
				width: 481
				height: 428
				force: false
			}
		}, (err, result)->
			return next(err) if err

			# Remove temp files
			fs.unlink(imgPath)

			res.json {
				url: path.resolve(result)
			}

	app.put '/design/theme/:themeId/chose/wallpaper/:wpId', __auth, (req, res, next)->
		themeId = req.param('themeId')

		# Chose or upload wallpaper
		wpId = req.param('wpId')
		res.end 'todo: chose wallpaper'

	app.put '/design/theme/:themeId/chose/iconset/:iconSet', __auth, (req, res, next)->
		themeId = req.param('themeId')

		iconsetId = req.param('iconSet')

		res.end 'todo: chose iconset'