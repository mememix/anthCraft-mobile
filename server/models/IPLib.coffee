mongoose = require 'mongoose'
Schema = mongoose.Schema
###
{
  "_id" : ObjectId("5347cb099e502e09e0759110"),
  "id" : 1,
  "start_ip" : "1.0.0.0",
  "end_ip" : "1.0.0.255",
  "start" : NumberLong(16777216),
  "end" : NumberLong(16777471),
  "code" : "AU",
  "country" : "Australia"
}
###

# READONLY
IPLibSchema = new Schema {
	start: 'number'
	end: 'number'
	code: 'string'
	country: 'string'
}, { collection: 'ipv4Country' }


IPLibSchema.statics.getCountry = (ipnum, callback)->
	this.findOne {
		start: { $lte: ipnum }
		end: { $gte: ipnum }
	}
	.exec (err, result)-> callback(err, result or 'null')

IPLibModel = mongoose.model 'IPLib', IPLibSchema

module.exports = IPLibModel
