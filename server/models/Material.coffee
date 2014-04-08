mongoose = require 'mongoose'
Schema = mongoose.Schema

MaterialSchema = new Schema {
	categoryName: 'string'

	# resType|resName
	categoryId: 'string'

	# {
	# 	"height" : 192,
	# 	"width" : 192,
	# 	"original" : true,
	# 	"path" : "/resourceslib/213/533e6493a9e23d8266ee50a5/o_1396597907084.png",
	# 	"ext" : "png"
	# }
	files: [mongoose.Schema.Types.Mixed]
	orderNum: 'number'

	# 1 - enabled
	# 0 - disabled
	status: 'number'
	uploadTime: 'date'
}

MaterialSchema.statics.listWallpaperByPage = (page, pageCount, done)->
	skipCount = (page - 1) * pageCount
	this
		.find({
			categoryId: 'wallpaper|wallpaper-hd'
			status: 1
		})
		.sort('orderNum')
		.skip(skipCount)
		.limit(pageCount)
		.exec done

module.exports = WallpaperModel = mongoose.model 'resource', MaterialSchema
