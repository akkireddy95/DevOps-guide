sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios

sudo apt-get update 
sudo apt-get install -y apache2 build-essential libgd2-xpm-dev openssl libssl-dev xinetd apache2-utils unzip
sudo apt-get install -y mysql-server php5 php5-mysql php5-gd  libapache2-mod-php5

#Nagios core...ReQUIRED FOR ONLY FOR SERVER. 
#download nagios core...0
cd ~
curl -L -O https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.2.1.tar.gz
 tar xvf nagios-*.tar.gz
cd nagios-*
./configure --with-nagios-group=nagios --with-command-group=nagcmd 
make all
    sudo make install
    sudo make install-commandmode
    sudo make install-init
    sudo make install-config
    sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

	sudo usermod -G nagcmd www-data
#Plugins
cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz
tar xvf nagios-plugins-*.tar.gz
cd nagios-plugins-*
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make
sudo make install
#NRPE
    cd ~
    curl -L -O http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
	
	#curl -L -O https://github.com/NagiosEnterprises/nrpe/archive/3.0.1.tar.gz
	# DONOT USE ABOVE UNLESS CORRESPONDING VERSIONS OF NAGIOS AND PLUGINS ARE ALSO UPDATED
tar xvf nrpe-*.tar.gz
cd nrpe-*
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu

    make all
    sudo make install
    sudo make install-xinetd
    sudo make install-daemon-config
# sudo vi /etc/xinetd.d/nrpe
# edit only_allow
sudo service xinetd restart
#Configure Nagios
# sudo vi /usr/local/nagios/etc/nagios.cfg
sudo mkdir /usr/local/nagios/etc/servers
sudo mkdir /usr/local/nagios/etc/servers
# sudo vi /usr/local/nagios/etc/objects/commands.cfg
# Add below lines
# define command{
#         command_name check_nrpe
#         command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
# }
#Confgure Apache
sudo a2enmod rewrite
sudo a2enmod cgi
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
sudo ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/
sudo service nagios start
sudo service apache2 restart
sudo ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios
