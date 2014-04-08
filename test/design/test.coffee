
request = require 'supertest'
express = require 'express'
should = require 'should'

process.env.NODE_ENV = 'test'

server = require '../../server/index'

describe 'Http Server Test', ->
	agent = null
	before (done)->
		server.launch (err, app)->
			agent = request.agent(app)
			done()

	it 'should return status 200 for index page', (done)->
		agent
			.get('/store')
			.expect(200)
			.end done

	#todo: more test suits
