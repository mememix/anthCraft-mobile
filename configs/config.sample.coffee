#############################
# 提示：修改 #!! 标记的下一行内容
#############################
path = require 'path'
basePath = path.join(__dirname, '..')

module.exports = {
	debug: false
	#!! 监听端口
	port: 89757
	#!! 绑定ip地址
	host: '0.0.0.0'
	liveReloadPort: 35729

	routePath: "#{basePath}/server/routes"
	modelPath: "#{basePath}/server/models"
	viewPath: "#{basePath}/views"

	viewVars: {
		RESOURCE_PATH: 'http://designer.c-launcher.com/resources'
		UPLOAD_PATH: 'http://designer.c-launcher.com/resources/upload'
		WALLPAPER_PATH: 'http://s.c-launcher.com/resources/wallpaper/img'
		THEME_PATH: 'http://s.c-launcher.com/resources/themes'
		THEME_THUMBNAIL_PATH: 'http://s.c-launcher.com/resources/thumbnail'
		THEME_PREVIEW_PATH: 'http://s.c-launcher.com/resources/preview'
		ICONSET_PATH: 'http://s.c-launcher.com/resources/upload'
	}

	mongodb: {
		#!! MongoDB 连接配置
		url: "mongodb://10.60.145.18:27017/anthcraft"
	}

	anthPack: {
		#!! 资源文件夹路径（与anthCraft-dist共享）
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
				#!! 日志文件路径
				filename: "#{basePath}/logs/anthpack.log"
				maxLogSize: 204800
				backups: 3
				category: "anthpack"
			}
			{
				type: 'file'
				#!! 日志文件路径
				filename: "#{basePath}/logs/master.log"
				maxLogSize: 204800
				backups: 3
				category: "master"
			}
		],
		replaceConsole: true
	}

	apiService: {
		account: {
			login_aesKey: 'nadcmalogin'
			register_aesKey: 'nadcmaregister'

			# http://themes.c-launcher.com/user/login3.do?username=chenhua&password=asdf1234(正式路径)
			# http://test.themes.c-launcher.com/user/login3.do?username=chenhua&password=asdf1234(测试路径)
			# http://10.12.0.71:8080/shop/user/login3.do?username=chenhua&password=asdf1234(本地访问)
			validateUser: {
				host: 'themes.c-launcher.com',
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
			    host: 'themes.c-launcher.com',
			    port: 3721,
			    path: '/user/register2.do',
			    method: 'GET',
			    headers: {
			        accept: 'application/json'
			    }
			}
		}
	}

}