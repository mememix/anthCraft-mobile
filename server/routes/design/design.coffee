mongoose = require 'mongoose'
MaterialModel = mongoose.model 'resource'
IconSetModel = mongoose.model 'IconGroups'
async = require 'async'

themeConfig = require '../../../configs/themeConfig.coffee'

module.exports = (app, middlewares)->

	pageVolumn = 8
	iconVolumn = 12
	# design/index page, aka wallpaper diy page
	app.get '/design', middlewares.auth, (req, res)->
		# Default to theme diy page
		res.redirect '/design/theme'

	app.get '/design/theme', middlewares.auth, (req, res)->
		page = 1
		async.parallel {
			wallpapers: (cb)->
				MaterialModel.listWallpaperByPage(page, pageVolumn, cb)

			iconSets: (cb)->
				IconSetModel.listByPage(page, iconVolumn, cb)

			themeId: (cb)->
				# Create new themeId
				req.session.themeId = mongoose.Types.ObjectId.createPk()
				cb null, req.session.themeId
			theme: (cb)->
				cb null, {
					preview : [
						"/images/detail.jpg"
					]
				}
		}, (err, result)->
			return next(err) if err

			# Create packData in session
			req.session.packData = {
				meta: {
					_id: result.themeId
					userId: req.user.userId
				}
				packInfo: themeConfig.defaultPackInfo
			}
			result.username = req.cookies.username
			res.render 'design/index', result

	app.get '/design/more/wallpaper', (req, res)->
		page = req.param('page') || 1
		MaterialModel.listWallpaperByPage page, pageVolumn, (err, result)->
			return next(err) if err

			#res.json result
			res.render 'design/moreWallpaper', {
				wallpapers: result
				next_page: ++page
			}

	app.get '/design/more/iconset', (req, res)->
		page = req.param('page')
		IconSetModel.listByPage page, iconVolumn, (err, result)->
			return next(err) if err

			#res.json result
			res.render 'design/moreIcon', {
				iconSets: result
				next_page: ++page
			}
