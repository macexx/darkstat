#!/bin/bash

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Configure user nobody to match unRAID's settings
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /home nobody
chown -R nobody:users /home

# Disable SSH
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh


#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################

# Repositories
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list


# Update and dependencies
apt-get update -qq
apt-get install wget libpcap0.8


#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################

# Set premissions on database and log directory
mkdir -p /config
chown -R nobody:users /config
chmod 755 -R /config


#########################################
##             INTALLATION             ##
#########################################

#Install dakrstat
wget https://launchpad.net/ubuntu/+source/darkstat/3.0.718-2/+build/5937806/+files/darkstat_3.0.718-2_amd64.deb -P /tmp/
dpkg -i /tmp/dark*


# Start script for configuring darkstat
cat <<'EOT' > /etc/my_init.d/config.sh
#!/bin/bash

echo START_DARKSTAT=yes > /etc/darkstat/init.cfg
echo INTERFACE="\"-i $ETH"\" >> /etc/darkstat/init.cfg
echo DIR="\"/config\"" >> /etc/darkstat/init.cfg
echo PORT="\"-p $PORT\"" >> /etc/darkstat/init.cfg
echo BINDIP="\"-b $IP_HOST\"" >> /etc/darkstat/init.cfg
echo LOCAL="\"-l $IP_RANGE\"" >> /etc/darkstat/init.cfg
echo DAYLOG="\"--daylog darkstat.log\"" >> /etc/darkstat/init.cfg
EOT

# Start script for darkstat
cat <<'EOT' > /etc/my_init.d/start_darkstat.sh
#!/bin/bash

service darkstat restart
EOT

# Make start scripts executable
chmod -R +x /etc/my_init.d/


#########################################
##                 CLEANUP             ##
#########################################

# Clean APT install files
apt-get clean -y
rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/*
