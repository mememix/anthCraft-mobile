mongoose = require 'mongoose'
WallpaperModel = mongoose.model 'wallpaper'
IconSetModel = mongoose.model 'IconGroups'
async = require 'async'

module.exports = (app, middlewares)->

	# design/index page, aka wallpaper diy page
	app.get '/design', middlewares.auth, (req, res)->
		# Default to theme diy page
		res.redirect '/design/theme'

	app.get '/design/theme', middlewares.auth, (req, res)->
		page = 1
		pageVolumn = 6

		async.parallel {
			wallpapers: (cb)->
				WallpaperModel.listByPage(page, pageVolumn, cb)

			iconSets: (cb)->
				IconSetModel.listByPage(page, pageVolumn, cb)

			themeId: (cb)->
				cb null, mongoose.Types.ObjectId.createPk()
		}, (err, result)->

			return next(err) if err

			# Create packData in session
			req.session.packData = {
				meta: {
					_id: result.themeId
					userId: req.user.userId
				}
				packInfo: {}
			}

			res.render 'design/index', result

