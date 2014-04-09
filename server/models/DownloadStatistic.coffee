mongoose = require 'mongoose'
Schema = mongoose.Schema
###
private static final int STATUS_ENABLE = 1;
private static final int STATUS_DISABLE = 0;
private String id;
private int iconGroupId;//组编号
private String name;//图标组名
private int typeId;//分类编号,暂时没有，设置为0
private String preview;//图标组预览图路径,如../../perview.png
private Map<String,Map<String,Map<String,Object>>> icons = new HashMap<String,Map<String,Map<String,Object>>>();//{"app_icon":{"Phone":{cap}}}
private Date createTime;//生成时间
private int status;//状态
private int orderNum;//显示顺序
我不能如此孤独，可是我却恋上了这样的孤独
###

# READONLY Model
DownloadStatisticSchema = new Schema {
	id: 'string'
	iconGroupId: 'number'
	name: 'string'
	typeId: 'number'
	preview: 'string'
	icons: mongoose.Schema.Types.Mixed
	createTime: 'date'
	status: 'number'
	orderNum: 'number'
}

DownloadStatisticSchema.statics.listByPage = (page, pageCount, cb)->
	skipCount = (page-1) * pageCount
	this
		.find({
			status: 1
		})
		.sort('-updateTime')
		.skip(skipCount)
		.limit(pageCount)
		.exec cb

DownloadStatisticModel = mongoose.model 'themedownloadall', DownloadStatisticSchema

module.exports = DownloadStatisticModel
