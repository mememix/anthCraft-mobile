mongoose = require 'mongoose'
Schema = mongoose.Schema
autoinc = require 'mongoose-id-autoinc2'

default_producer = __config.packageInfo.name + '-' + __config.packageInfo.version

ThemeSchema = new Schema {
	themeId: {
		type: 'number'
	}

	# 父主题id
	forkFrom: {
		type: 'string'
		default: null
	}

	# 标题
	title: {
		type: 'string',
		trim: true,
		# match: [/^.{3,40}$/, 'Theme name length must between 3 and 40.'],
		default: 'Awesome theme'
	}

	# 描述
	description: {
		type: 'string',
		trim: true,
		default: ''
	}

	userId: {
		type: 'string',
		default: null
	}
	# 用户称呼（作者）
	author: {
		type: 'string',
		default: ''
	}
	category: {
		type: 'string',
		trim: true,
		default: ''
	}
	tag: {
		type: 'string',
		trim: true,
		default: ''
	}
	userTag: {
		type: 'string',
		trim: true,
		default: ''
	}
	# 缩略图
	thumbnail: {
		type: 'string',
		default: ''
	}
	# 下载次数
	downloads: {
		type: 'number',
		default: 0
	}
	# 发布状态
	published: {
		type: 'number',
		default: 0
	}

	# 是否公开
	isShared: {
		type: 'number',
		default: 1
	}
	# 付费价格
	charge: {
		type: 'number',
		default: 0
	}

	# 预览图 [url]
	preview: [ 'string' ]

	# 主题包下载地址
	# [{
	# 	density: 160 #密度(160,240,320,480)
	# 	file: "xxx"
	# 	size: 245
	# }]
	packageFile: [mongoose.Schema.Types.Mixed]

	# 积分
	point: {
		type: "number"
		default: 0
	}

	# 评价
	grade: {
		type: "number"
		default: 0
	}

	# 状态：
	# 	0	待审核，
	# 	1	审核通过
	# 	2	审核不通过
	# 	3	正在下架
	# 	4	已经下架
	# 	99	未完成

	status: {
		type: "number"
		default: 99
	}

	weight: {
		type: "number"
		default: 100
	}

	updateTime: { type: 'date', default: Date.now }
	createTime: { type: 'date', default: Date.now }

	producer: {
		type: 'string'
		default: default_producer
	}

	# 主题更新包的上传时间
	packageTime: { type: 'date', default: null }
	# 主题更新包之前的下载次数，默认为0
	# 后台更新主题包，或者制作站替换主题包（只有主题包有变化时）
	# 更新packageTime，并将downloads的值赋值给packageDownloads
	packageDownloads: { type: 'number', default: 0 }
}

ThemeSchema.statics.listByPage = (page, pageCount, cb)->
	skipCount = (page-1) * pageCount
	this
		.find({
			status: 2
		})
		.sort('-updateTime')
		.skip(skipCount)
		.limit(pageCount)
		.exec cb

# Config _id auto increase
ThemeSchema.plugin autoinc.plugin, {
	model: 'theme',
	field: 'themeId',
	start: 100,
	step: 1
}


module.exports = ThemeModel = mongoose.model 'theme', ThemeSchema