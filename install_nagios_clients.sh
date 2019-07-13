sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios

sudo apt-get update 
sudo apt-get install -y  build-essential libgd2-xpm-dev openssl libssl-dev xinetd  unzip
# WE DO NOT NEED MYSQL OR PHP OR APACHE ON CLIENTS
# WE ONLY NEED PLUgiNS/NRPE 
#sudo apt-get install -y mysql-server php5 php5-mysql php5-gd  libapache2-mod-php5
#Plugins
cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz
tar xvf nagios-plugins-*.tar.gz
cd nagios-plugins-*
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make
sudo make install
#NRPE
    cd ~
    curl -L -O http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
tar xvf nrpe-*.tar.gz
cd nrpe-*
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu

    make all
    sudo make install
    sudo make install-xinetd
    sudo make install-daemon-config
