
crypto = require 'crypto'

should = require 'should'

str = 'chenhua'
key1 = 'nadcmaregister'
key2 = 'nadcmalogin'

des1 = '821E2517024862CC11D2D0D57F2D5715'
des2 = '07875565C9A4872D8049FF02CA4B793D'

cipher = crypto.createCipher('aes-128-ecb', key1)
ced = cipher.update(str, 'utf8', 'hex') + cipher.final('hex')

des1.should.be.equal(ced.toUpperCase())
