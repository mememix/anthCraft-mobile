
request = require 'supertest'
should = require 'should'
cheerio = require 'cheerio'

process.env.NODE_ENV = 'test'

server = require '../../server/index'

describe 'Http Server Test', ->
	agent = null
	clientData = {}

	before (done)->
		# Launch server
		server.launch (err, app)->
			agent = request.agent(app)
			done()

	it 'should return status 200 for index page', (done)->
		agent
			.get('/store')
			.expect(200)
			.end (err, res)->
				done()

	# will use api on test server
	it.skip 'login user', (done)->
		agent
			.post('/login')
			.send({
				username: 'tester'
				password: 'abc'
			})
			.expect(200)
			.end done

	it 'Visit /design/theme page, get themeId', (done)->
		agent
			.get('/design/theme')
			.expect(200)
			.end (err, res)->
				$ = cheerio.load(res.text)
				# Find themeId and save
				clientData.themeId = $('input[name=_id]').val()
				done()

	describe 'Store page Test', ->

		it 'should redirect to theme download url with 302', (done)->

			agent
				.get '/store/theme/89797/download?path=/test/abc.apk'
				# .send {
				# 	path: '/test/abc.apk'
				# }
				.expect 302
				.end done

		it 'should redirect to wallpaper download url with 302', (done)->

			agent
				.get '/store/wallpaper/89797/download?path=/test/wallpaper.jpg'
				# .send {
				# 	path: '/test/abc.apk'
				# }
				.expect 302
				.end done

	describe 'AnthPack Test', ->

		it 'should upload wallpaper and return formatted image', (done)->

			agent
				.post("/design/theme/#{clientData.themeId}/upload/wallpaper")
				.attach("wpFile", "test/design/attachments/2-121123212G54J.jpg")
				.expect(200, (err, res)->
					resjson = res.body
					resjson.success.should.be.true
					resjson.url.should.be.type('string')
					done()
				)

		it.skip 'should chose the material as theme wallpaper', (done)->
			# todo

		it 'should return package theme preview images', (done)->
			agent
				.post("/design/theme/#{clientData.themeId}/preview")
				.expect(200, (err, res)->
					res.body.should.have.property('previewList').with.lengthOf(3)
					res.body.should.have.property('thumbnail')
					done()
				)

		it 'should package theme and return apk download url', (done)->
			agent
				.post("/design/theme/#{clientData.themeId}/package")
				.send({
					themeTitle: 'Test Theme Title'
					isShare: 1
				})
				.expect(200, (err, res)->
					res.text.should.match(/Package Succeeded/)
					done()
				)