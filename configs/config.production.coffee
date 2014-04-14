
path = require 'path'
basePath = path.join(__dirname, '..')

module.exports = {
	debug: false
	port: 3721
	liveReloadPort: 35729
	host: '0.0.0.0'

	routePath: "#{basePath}/server/routes"
	modelPath: "#{basePath}/server/models"
	viewPath: "#{basePath}/views"

	viewVars: {
		RESOURCE_PATH: 'http://test.designer.c-launcher.com/resources'
		UPLOAD_PATH: 'http://test.designer.c-launcher.com/resources/upload'
		WALLPAPER_PATH: 'http://test.designer.c-launcher.com/resources/wallpaper/img'
		THEME_PATH: 'http://test.designer.c-launcher.com/resources/themes'
		THEME_THUMBNAIL_PATH: 'http://test.designer.c-launcher.com/resources/thumbnail'
		THEME_PREVIEW_PATH: 'http://test.designer.c-launcher.com/resources/preview'
		ICONSET_PATH: 'http://test.designer.c-launcher.com/resources/upload'
	}

	mongodb: {
    #url: "mongodb://10.60.145.18:27017/anthcraft"
		url: "mongodb://10.52.201.81:27017/anthcraft"
	}
	memcached: {
    #hosts: [ "10.60.145.17:11211" ]
		hosts: [ "63.221.201.80:11211" ]
		prefix: 'anthCraft-mobile'
	}

	apiService: {
		account: {
			login_aesKey: 'nadcmalogin'
			register_aesKey: 'nadcmaregister'

			# http://themes.c-launcher.com/user/login3.do?username=chenhua&password=asdf1234(正式路径)
			# http://test.themes.c-launcher.com/user/login3.do?username=chenhua&password=asdf1234(测试路径)
			# http://10.12.0.71:8080/shop/user/login3.do?username=chenhua&password=asdf1234(本地访问)
			validateUser: {
				host: 'localhost',
				port: 3721,
				path: '/user/login3.do',
				method: 'GET',
				headers: {
					accept: 'application/json'
				}
			}

			# http://themes.c-launcher.com/user/register2.do?email=&username=&password=&source=4(正式路径)
			# http://test.themes.c-launcher.com/user/register2.do?email=&username=&password=&source=4(测试路径)
			# http://10.12.0.71:8080/shop/user/register2.do?email=&username=&password=&source=4(本地访问)
			registerUser: {
			    host: 'localhost',
			    port: 3721,
			    path: '/user/register2.do',
			    method: 'GET',
			    headers: {
			        accept: 'application/json'
			    }
			}
		}
	}

	anthPack: {
		debug_mode: true
		base_path: "/home/webadmin/anthCraft-dist/public/resources"
		package_path: "/resources/themes"
		develop_path: "/resources/upload"
		preview_path: "/resources/preview"
		thumb_path: "/resources/thumbnail"
		archive_path: "/resources/themeArchives"
	}

	log4js: {
		appenders: [
			{ type: "console" }
			{
				type: 'file'
				filename: "#{basePath}/logs/anthpack.log"
				maxLogSize: 204800
				backups: 3
				category: "anthpack"
			}
			{
				type: 'file'
				filename: "#{basePath}/logs/master.log"
				maxLogSize: 204800
				backups: 3
				category: "master"
			}
		],
		replaceConsole: true
	}
}
