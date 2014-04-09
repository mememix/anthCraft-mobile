mongoose = require 'mongoose'
Schema = mongoose.Schema
###
private int userId; // 0非登录用户，大于0表示登录用户下载
private String country; // 国家简称，不能获取标记为"None"
private String serial; // 手机serial，不能获取标记为"null"
private String userMac; // MAC地址，不能获取标记为"null"
private int resourceType; // 0主题，1壁纸
private int source; // 下载来源：0手机端，1PC端
我不能如此孤独，可是我却恋上了这样的孤独
###

DownloadStatisticSchema = new Schema {
	userId: {
		type: 'number'
		default: 0
	}
	userEmail: {
		type: 'string'
		default: 'null'
	}
	themeId: {
		type: 'number'
		default: 0
	}
	country: {
		type: 'string'
		default: 'None'
	}
	serial: {
		type: 'string'
		default: 'null'
	}
	userMac: {
		type: 'string'
		default: 'null'
	}
	# 0主题，1壁纸
	resourceType: 'number'

	#下载来源：0手机端，1PC端
	source: 'number'

	createTime: {
		type: 'string'
		default: ''
	}
}, { collection: 'themedownloadall' }

DownloadStatisticModel = mongoose.model 'DownloadStatistic', DownloadStatisticSchema

module.exports = DownloadStatisticModel
