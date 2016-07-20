# 配置管理demo
1. 主要思路是：

	1. 构建一个统一的配置管理容器，将不同环境的配置文件存放在此容器中，配置文件是通过Dockerfile的COPY或者通过共享文件挂载卷的方式加载到容器中。此容器内置nginx服务，可以下载或读取配置文件。（如：开发环境配置文件endpoint：http://IPADDR/dev.properties。测试环境配置文件endpoint：http://IPADDR/test.properties。生产环境配置文件endpoint：http://IPADDR/online.properties。）
	
	2. 构建一个sample应用容器，容器启动时，通过"-e CONFIG=http://IPADDR/dev.properties" 指定环境所需的配置文件的endpoint，应用通过此endpoint加载读取配置文件。
	

1. 构建配置管理容器。将所有配置文件拷贝或者挂载到此容器中的nginx发布目录，通过nginx服务下载或读取配置文件。

		#-------------------------------------
		#构建/发布配置管理镜像
		#-------------------------------------
		cd config 
		docker build -t config .
		docker run --net=host -d config (why must host?FIXME)

2. 构建sample应用容器。index.jsp通过容器env获得配置文件链接并读取配置文件。

		#-------------------------------------
		# For Weblogic12.2.1
		#-------------------------------------
		cd sample 
		# 构建/发布weblogic12.2.1 sample应用镜像
		docker build -t sample:weblogic -f Dockerfile.weblogic .
		#开发环境发布应用
		docker run -p 8001:8001 -e CONFIG=http://IPADDR/dev.properties -d sample:weblogic
		＃测试环境发布应用
		docker run -p 8001:8001 -e CONFIG=http://IPADDR/test.properties -d sample:weblogic
		＃生产环境发布应用
		docker run -p 8001:8001 -e CONFIG=http://IPADDR/oneline.properties -d sample:weblogic
		＃准生产环境发布应用
		docker run -p 8001:8001 -e CONFIG=http://IPADDR/pre-online.properties -d sample:weblogic
		
		#-------------------------------------
		# For tomcat 8.0
		#-------------------------------------
		cd sample
		#构建tomcat8.0 sample应用镜像
		docker build -t sample:tomcat -f Dockerfile.tomcat .
		#开发环境发布应用
		docker run -p 8080:8080 -e CONFIG=http://IPADDR/dev.properties -d sample:tomcat
		＃测试环境发布应用
		docker run -p 8080:8080 -e CONFIG=http://IPADDR/test.properties -d sample:tomcat
		＃生产环境发布应用
		docker run -p 8080:8080 -e CONFIG=http://IPADDR/oneline.properties -d sample:tomcat
		＃准生产环境发布应用
		docker run -p 8080:8080 -e CONFIG=http://IPADDR/pre-online.properties -d sample:tomcat
		
3. TODO
	
	当前解决方案，应用程序需要做些修改，考虑把配置文件下载到本地，之后通过命令行参数传给应用程序，兼容程序代码。
	
	可以考虑构建配置管理服务提供get/refresh配置项等API，提供事件注册和通知，或加上zookeeper实现配置同步。
	
	
		
		
		
