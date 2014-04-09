mongoose = require 'mongoose'
MaterialModel = mongoose.model 'resource'
IconSetModel = mongoose.model 'IconGroups'
async = require 'async'

themeConfig = require '../../../configs/themeConfig.coffee'

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
				MaterialModel.listWallpaperByPage(page, pageVolumn, cb)

			iconSets: (cb)->
				IconSetModel.listByPage(page, pageVolumn, cb)

			themeId: (cb)->
				cb null, mongoose.Types.ObjectId.createPk()
			screens: (cb)->
				cb null, [
					{
						src:"/images/detail.jpg"
					}
					{
						src:"/images/detail.jpg"
					}
					{
						src:"/images/detail.jpg"
					}
					{
						src:"/images/detail.jpg"
					}
					{
						src:"/images/detail.jpg"
					}
				]
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
		page = req.param('page')
		pageVolumn = 6
		MaterialModel.listWallpaperByPage page, pageVolumn, (err, result)->
			return next(err) if err

			#res.json result
			res.render 'design/moreWallpaper',{ 
				wallpapers:result
				next_page: ++page
			}

	app.get '/design/more/iconset', (req, res)->
		page = req.param('page')
		pageVolumn = 6
		IconSetModel.listByPage page, pageVolumn, (err, result)->
			return next(err) if err

			#res.json result
			res.render 'design/moreIcon',{ 
				icons:result
				next_page: ++page
			}
