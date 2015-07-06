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
apt-get install libpcap0.8


#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################

# Set premissions on database and log directory
mkdir -p /config
chown -R nobody:users /config
chmod 755 -R /config

# Darkstat Service
mkdir -p /etc/service/darkstat

cat <<'EOT' > /etc/service/darkstat/run
#!/bin/bash
chown -R nobody:users /config
/usr/local/sbin/darkstat -i $ETH  -p $PORT -b $IP_HOST -l $IP_RANGE --no-daemon --chroot /config/ --daylog darkstat.log --import darkstat.db --export darkstat.db --user nobody
EOT


#########################################
##             INTALLATION             ##
#########################################

#Install darkstat
dpkg -i /files/dark*

# Make start scripts executable
chmod -R +x /etc/my_init.d/ /etc/service/


#########################################
##                 CLEANUP             ##
#########################################

# Clean APT install files
apt-get clean -y
rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/*
