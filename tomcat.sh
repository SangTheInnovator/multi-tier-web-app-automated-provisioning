# Install Dependencies
dnf -y install java-11-openjdk java-11-openjdk-devel
dnf install git maven wget -y

# Change dir to /tmp
cd /tmp/

# Download & Tomcat Package
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz 
tar xzvf apache-tomcat-9.0.75.tar.gz

# Add tomcat user
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat

# Copy data to tomcat home dir
cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/

# Make tomcat user owner of tomcat home dir
chown -R tomcat.tomcat /usr/local/tomcat

# Setup systemctl command for Tomcat
rm -rf /etc/systemd/system/tomcat.service

cat <<EOT >> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]

User=tomcat
Group=tomcat

WorkingDirectory=/usr/local/tomcat

#Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre

Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat

ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh


RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

EOT

# Reload systemd files
systemctl daemon-reload

# Start & Enable service
systemctl start tomcat
systemctl enable tomcat 

# Clone code and deploy on app01
# -------------------------------

# Download source code
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project

# Build code
mvn install

# Deploy artifact
systemctl stop tomcat
sleep 20
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
systemctl start tomcat
sleep 20
# -------------------------------

# Enable the firewall and allowing port 8080 to access the tomcat
systemctl start firewalld
systemctl enable firewalld
systemctl restart tomcat

