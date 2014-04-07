mongoose = require 'mongoose'
WallpaperModel = mongoose.model 'wallpaper'
IconSetModel = mongoose.model 'IconGroups'

anthpack = require 'anthpack'
fs = require 'fs'
path = require 'path'
async = require 'async'
extendUtil = require '../../utils/extendUtil'

module.exports = (app)->

	# Generate preview images
	app.post '/design/theme/:themeId/preview', __auth, (req, res, next)->
		themeId = req.param('themeId')
		packData = req.session.packData
		packData.themeId = themeId

		# Generate preview images and theme thumbnail
		anthpack.preview packInfo, (err, previews, thumbnail)->
			return next(err) if err

			packData = req.session.packData
			packData.meta.preview = previews
			packData.meta.thumbnail = thumbnail

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
		packData = req.session.packData

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

			wpUrl = path.resolve(result)

			# Update session data
			packData.packInfo.wallpaper.wallpaper = wpUrl
			packData.packInfo.wallpaper['wallpaper-hd'] = wpUrl

			# req.session.packData = packData

			res.json {
				success: true
				url: wpUrl
			}

	app.put '/design/theme/:themeId/chose/wallpaper/:wpId', __auth, (req, res, next)->
		themeId = req.param('themeId')
		packData = req.session.packData

		# Chose or upload wallpaper
		wpId = req.param('wpId')

		WallpaperModel.findById wpId, (err, result)->
			return next(err) if err

			packData.packInfo.wallpaper.wallpaper = result.bigPath
			packData.packInfo.wallpaper['wallpaper-hd'] = result.bigPath

			# req.session.packData = packData

			res.json {
				success: true
			}

	app.put '/design/theme/:themeId/chose/iconset/:iconSet', __auth, (req, res, next)->
		themeId = req.param('themeId')
		packData = req.session.packData

		iconsetId = req.param('iconSet')

		IconSetModel.findById iconsetId, (err, result)->
			return next(err) if err

			# Extend packInfo with wallpaper and other icons
			# result.icons not include wallpaper
			packInfo = extendUtil {}, packData.packInfo, result.icons

			req.session.packData.packInfo = packInfo

			res.json {
				success: true
			}

