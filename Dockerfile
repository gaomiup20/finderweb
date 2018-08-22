FROM centos:7
MAINTAINER gaomi.gm

# reconfig timezone
ENV TIME_ZONE Asia/Shanghai

#dockerfile
RUN ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

#安装必要应用
RUN yum -y install kde-l10n-Chinese glibc-common wget unzip

#设置编码
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

#设置环境变量
ENV LC_ALL zh_CN.utf8

#安装jdk
ADD jdk-8u45-linux-x64.tar.gz /usr/local
ENV JAVA_HOME /usr/local/jdk1.8.0_45

#安装tomcat
ADD apache-tomcat-8.5.32.tar.gz /usr/local
COPY server.xml /usr/local/apache-tomcat-8.5.32/conf

#设置环境变量

ENV JAVA_HOME=/usr/local/jdk1.8.0_45
ENV PATH=$JAVA_HOME/bin:$PATH
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

#安装finderweb
RUN rm -rf /usr/local/apache-tomcat-8.5.32/webapps/ROOT  && mkdir -p /usr/local/apache-tomcat-8.5.32/webapps/ROOT
RUN chmod -R 755 /usr/local/apache-tomcat-8.5.32/webapps/ROOT
RUN  wget -P /usr/local/apache-tomcat-8.5.32 http://www.finderweb.net/download/finder-web-2.4.5.war
RUN  mv /usr/local/apache-tomcat-8.5.32/finder-web-2.4.5.war /usr/local/apache-tomcat-8.5.32/finder-web-2.4.5.zip
RUN  unzip -o -d /usr/local/apache-tomcat-8.5.32/webapps/ROOT /usr/local/apache-tomcat-8.5.32/finder-web-2.4.5.zip

#设置工作目录
WORKDIR /usr/local/apache-tomcat-8.5.32
EXPOSE 7080 7005 7089 7443 7009
ENTRYPOINT /usr/local/apache-tomcat-8.5.32/bin/startup.sh && tail -f /usr/local/apache-tomcat-8.5.32/logs/catalina.out
