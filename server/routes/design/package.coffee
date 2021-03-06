mongoose = require 'mongoose'
MaterialModel = mongoose.model 'resource'
IconSetModel = mongoose.model 'IconGroups'
ThemeModel = mongoose.model 'theme'

anthPack = require 'anthpack'
fs = require 'fs'
path = require 'path'
async = require 'async'
extendUtil = require '../../utils/extendUtil'
themeConfig = require '../../../configs/themeConfig.coffee'

module.exports = (app, middlewares)->

	# Generate preview images
	app.post '/design/theme/:hash/preview', middlewares.auth, (req, res, next)->
		themeId = req.session.themeId
		packData = req.session.packData
		packData.packInfo.themeId = themeId

		# Generate preview images and theme thumbnail
		anthPack.preview packData.packInfo, (err, previews, thumbnail)->
			return next(err) if err

			# packData = req.session.packData
			packData.meta.preview = previews
			packData.meta.thumbnail = thumbnail

			res.json {
				previewList: previews
				thumbnail: thumbnail
			}

	app.post '/design/theme/:hash/package', middlewares.auth, (req, res, next)->
		themeId = req.session.themeId
		themeTitle = req.body.themeTitle
		isShare = req.body.isShare

		themeData = req.session.packData

		# Update theme meta info
		themeData.meta.title = themeTitle
		themeData.meta.isShare = isShare

		async.waterfall [

			(callback)->
				# Create theme record in database
				# ThemeModel.create themeData.meta, callback
				theme = new ThemeModel(themeData.meta)
				callback(null, theme)

			(theme, ..., callback)->
				__log "Generate previews: ", themeData.packInfo
				themeData.packInfo.themeId = themeId

				# Generate preview images
				anthPack.preview themeData.packInfo, (err, result, thumbnail)->
					return callback(err) if err
					__log "Finish preview."
					theme.preview = result
					theme.thumbnail = thumbnail
					# Save later with package result
					# theme.save callback
					callback(null, theme)

			(theme, ..., callback)->
				packParams = themeData.packInfo
				packParams.meta = theme.toObject()
				__log "Package theme: ", packParams

				# Package theme into 4-act and 1-apk file
				anthPack.packTheme packParams, (err, packagePaths)->
					return callback(err) if err
					__log "Success package."
					theme.packageTime = new Date()
					theme.packageFile = packagePaths
					theme.status = 0

					# Everytime theme save, themeId inc
					# but themeId isnt the real id of the record
					theme.save (err)->
						# refresh themeId
						# req.session.packData = {
						# 	meta: {
						# 		_id: req.session.themeId
						# 		userId: req.user.userId
						# 	}
						# 	# Remain user choice
						# 	# packInfo: themeConfig.defaultPackInfo
						# }
						callback(err, theme)

		], (err, results)->
			if err
				# show package fail page
				res.json {
					success: false
					message: err
				}
			else
				req.session.themeId = mongoose.Types.ObjectId.createPk()
				req.session.packData.meta._id = req.session.themeId
				req.session.packData.userId = req.user.userId

				# show package success page
				res.json {
					success: true
					themeId: req.session.themeId
					fileName: results.title
					apkFile: results.packageFile[4]
				}

	app.post '/design/theme/:hash/upload/wallpaper', middlewares.auth, (req, res, next)->
		themeId = req.session.themeId
		packData = req.session.packData

		imgPath = req.files.image.path

		anthPack.format {
			themeId: themeId
			type: 'wallpaper'
			name: 'wallpaper-hd'
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

			# Update session data
			packData.packInfo.wallpaper.wallpaper.src = result
			packData.packInfo.wallpaper['wallpaper-hd'].src = result

			# req.session.packData = packData

			res.json {
				success: true
				url: result
			}

	app.put '/design/theme/:hash/chose/wallpaper/:wpId', middlewares.auth, (req, res, next)->
		themeId = req.session.themeId
		packData = req.session.packData

		# Chose or upload wallpaper
		wpId = req.param('wpId')

		MaterialModel.findById wpId, (err, result)->
			return next(err) if err

			packData.packInfo.wallpaper.wallpaper.src = result.files[0].path
			packData.packInfo.wallpaper['wallpaper-hd'].src = result.files[0].path

			# req.session.packData = packData

			res.json {
				success: true
			}

	app.put '/design/theme/:hash/chose/iconset/:iconSet', middlewares.auth, (req, res, next)->
		themeId = req.session.themeId
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
