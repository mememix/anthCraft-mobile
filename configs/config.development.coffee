
path = require 'path'
basePath = path.join(__dirname, '..')

module.exports = {
	debug: true
	port: 9527
	liveReloadPort: 35729
	host: '0.0.0.0'

	routePath: "#{basePath}/server/routes"
	modelPath: "#{basePath}/server/models"
	viewPath: "#{basePath}/views"

	resourcePath: "e:/worktop/anthCraft/app/resources"
	viewVars: {
		RESOURCE_PATH: '/resources'
		WALLPAPER_PATH: '/resources/wallpaper'
		THEME_PATH: '/resources/themes'
	}

	mongodb: {
		url: "mongodb://admin:123@10.127.129.88:27017/anthcraft"
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
				port: 9527,
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
			    port: 9527,
			    path: '/user/register2.do',
			    method: 'GET',
			    headers: {
			        accept: 'application/json'
			    }
			}
		}
	}

	anthPack: {
		base_path: "e:/worktop/anthCraft/app/"
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