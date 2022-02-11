#! bin/sh/

sudo yum update

sudo groupadd --system tomcat

sudo useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat

sudo yum -y install wget

export VER="9.0.39"

wget https://archive.apache.org/dist/tomcat/tomcat-9/v${VER}/bin/apache-tomcat-${VER}.tar.gz

sudo tar xvf apache-tomcat-${VER}.tar.gz -C /usr/share/

sudo ln -s /usr/share/apache-tomcat-$VER/ /usr/share/tomcat

sudo chown -R tomcat:tomcat /usr/share/tomcat

sudo chown -R tomcat:tomcat /usr/share/apache-tomcat-$VER/

sudo tee /etc/systemd/system/tomcat.service<<EOF
[Unit]
Description=Tomcat Server
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment='JAVA_OPTS=-Djava.awt.headless=true'
Environment=CATALINA_HOME=/usr/share/tomcat
Environment=CATALINA_BASE=/usr/share/tomcat
Environment=CATALINA_PID=/usr/share/tomcat/temp/tomcat.pid
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M'
ExecStart=/usr/share/tomcat/bin/catalina.sh start
ExecStop=/usr/share/tomcat/bin/catalina.sh stop

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start tomcat

sudo systemctl enable tomcat

sudo systemctl status tomcat

