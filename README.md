#主要思路

* 构建一个统一的配置管理容器，将不同环境的配置文件存放在此容器中，配置文件是通过Dockerfile的COPY或者通过共享文件挂载卷的方式加载到容器中。此容器内置nginx服务，可以下载或读取配置文件。（如：开发环境配置文件endpoint：http://IPADDR/dev.properties。测试环境配置文件endpoint：http://IPADDR/test.properties。生产环境配置文件endpoint：http://IPADDR/online.properties。）
	
* 构建一个sample应用容器，容器启动时，通过"-e config_uri=http://IPADDR/dev.properties" 和 “-e config_file=/opt/dev.properties” 指定环境所需的配置文件的endpoint和下载到本地的文件目录和文件名。
	
* 容器启动时，执行/opt/loadconfig.sh,从配置中心拉取配置文件，下载到本地，之后重启tomcat或weblogic使其配置文件生效。（重启服务可以优化。）
	

#构建
* 构建配置管理容器。将所有配置文件拷贝或者挂载到此容器中的nginx发布目录，通过nginx服务下载或读取配置文件。

		#-------------------------------------
		#构建/发布配置管理镜像
		#-------------------------------------
		cd config 
		docker build -t config .
		docker run --net=host -d config (why must host?FIXME)

* 构建sample应用容器。index.jsp通过容器env获得配置文件链接并读取配置文件。

		#-------------------------------------
		# For tomcat 8.0
		#-------------------------------------
		cd sample
		#构建tomcat8.0 sample应用镜像
		docker build -t sample:tomcat -f Dockerfile.tomcat .
		#开发环境发布应用
		docker run -p 8080:8080 
			-e config_uri=http://IPADDR/dev.properties 
			-e config_file=/opt/dev.properties 
			-d sample:tomcat 
			/bin/bash -c "/opt/loadconfig.sh;/usr/local/tomcat/bin/catalina.sh stop;/usr/local/tomcat/bin/catalina.sh run"
		
		＃测试环境发布应用
		docker run -p 8080:8080 
			-e config_uri=http://IPADDR/test.properties 
			-e config_file=/opt/test.properties 
			-d sample:tomcat 
			/bin/bash -c "/opt/loadconfig.sh;/usr/local/tomcat/bin/catalina.sh stop;/usr/local/tomcat/bin/catalina.sh run"
		
		＃准生产环境发布应用
		docker run -p 8080:8080 
			-e config_uri=http://IPADDR/pre-online.properties 
			-e config_file=/opt/pre-online.properties 
			-d sample:tomcat 
			/bin/bash -c "/opt/loadconfig.sh;/usr/local/tomcat/bin/catalina.sh stop;/usr/local/tomcat/bin/catalina.sh run"
			
		＃生产环境发布应用
		docker run -p 8080:8080 
			-e config_uri=http://IPADDR/online.properties -e config_file=/opt/online.properties 
			-d sample:tomcat 
			/bin/bash -c "/opt/loadconfig.sh;/usr/local/tomcat/bin/catalina.sh stop;/usr/local/tomcat/bin/catalina.sh run"
		
		#-------------------------------------
		# For Weblogic12.2.1
		#-------------------------------------
		cd sample 
		# 构建/发布weblogic12.2.1 sample应用镜像
		docker build -t sample:weblogic -f Dockerfile.weblogic .
		#开发环境发布应用
		docker run -p 8001:8001 
			-e config_uri=http://IPADDR/dev.properties 
			-e config_file=//u01/oracle/dev.properties
			-d sample:weblogic
			/bin/bash -c "/u01/oracle/loadconfig.sh;stopWebLogic.sh;startWebLogic.sh"
		
		＃测试环境发布应用
		docker run -p 8001:8001 
			-e config_uri=http://IPADDR/test.properties 
			-e config_file=/u01/oracle/test.properties
			-d sample:weblogic
			/bin/bash -c "/u01/oracle/loadconfig.sh;stopWebLogic.sh;startWebLogic.sh"
		
		＃准生产环境发布应用
			-e config_uri=http://IPADDR/pre-online.properties 
			-e config_file=/u01/oracle/pre-online.properties
			-d sample:weblogic
			/bin/bash -c "/u01/oracle/loadconfig.sh;stopWebLogic.sh;startWebLogic.sh"
		
		＃生产环境发布应用
			-e config_uri=http://IPADDR/online.properties 
			-e config_file=/u01/oracle/online.properties
			-d sample:weblogic
			/bin/bash -c "/u01/oracle/loadconfig.sh;stopWebLogic.sh;startWebLogic.sh"
		
#TODO		
* 可以考虑构建配置管理服务提供get/refresh配置项等API，提供事件注册和通知，或加上zookeeper实现配置同步。
	
	
		
		
		
