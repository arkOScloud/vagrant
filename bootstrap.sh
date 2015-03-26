#!/usr/bin/env bash

# Trust arkOS signing key
mkdir /root/.gnupg
pacman-key -r 0585F850
pacman-key --lsign 0585F850

# Get prerequisites
pacman --noconfirm -Sy wget

# Install arkOS package repo details
wget -O /tmp/arkos-mirrorlist.pkg.tar.xz https://nyus.mirror.arkos.io/x86_64/arkos/arkos-mirrorlist-20150101-1-any.pkg.tar.xz
pacman --noconfirm -U /tmp/arkos-mirrorlist.pkg.tar.xz
curl "https://www.archlinux.org/mirrorlist/?country=CA&protocol=http&ip_version=4" 2>/dev/null > /etc/pacman.d/mirrorlist && sed -i 's/\#Server/Server/g' /etc/pacman.d/mirrorlist

# Update the system
#pacman --noconfirm -Syu

# Install system dependencies
pacman --noconfirm -Sy pkg-config gcc iptables python2 python2-pip redis arkos-redis openldap arkos-openldap python2-nginx python2-pacman python2-ntplib python2-passlib python2-pyopenssl python2-iptables python2-nginx python2-dbus python2-cryptsetup python2-pyparted python2-ldap python2-psutil python2-netifaces python2-gitpython python2-gnupg python2-flask python2-redis mysql-python nginx git postfix dovecot mariadb nodejs supervisor php php-fpm php-xcache php-tidy php-gd php-intl ruby uwsgi uwsgi-plugin-python2 php-sqlite python2-pgpdump python2-lxml spambayes

# Prepare arkOS working environment
mkdir -p /var/lib/arkos
cd /home/vagrant
if [ ! -d /home/vagrant/core ]
then
	git clone https://git.coderouge.co/arkOS/core.git core
fi
if [ ! -d /home/vagrant/kraken ]
then
	git clone https://git.coderouge.co/arkOS/kraken.git kraken
fi
if [ ! -d /home/vagrant/genesis ]
then
	git clone https://git.coderouge.co/arkOS/genesis.git genesis
	cd /home/vagrant/genesis
	git checkout 0.7
	npm install --save-dev ember-cli@0.2.0
fi
if [ ! -d /var/lib/arkos/applications ]
then
	git clone https://git.coderouge.co/arkOS/apps.git /var/lib/arkos/applications
fi
cd /home/vagrant/genesis
npm install -g bower ember-cli watchman
npm install
bower install --allow-root
ember build

cp /vagrant/arkostest.sh /home/vagrant/arkostest.sh
chmod +x /home/vagrant/arkostest.sh

# Make sure nginx uses the `sites-available` hierarchy
if [ ! -d /etc/nginx/sites-available ]
then
	mkdir -p /etc/nginx/sites-{available,enabled}
	mkdir -p /srv/http/webapps
	cp /vagrant/nginx.conf /etc/nginx/nginx.conf
fi

systemctl start arkos-redis
mkdir -p /etc/arkos
echo '{"ldap":"admin"}' > /etc/arkos/secrets.json
echo '{}' > /etc/arkos/policies.json

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl start mysqld
mysqladmin -u root password 'testpass'
mysqladmin -u root -h localhost -ptestpass password 'testpass'

echo "[client]" >> /root/.my.cnf
echo "user=root" >> /root/.my.cnf
echo "password=testpass" >> /root/.my.cnf

rm -r /var/cache/pacman/pkg/*
