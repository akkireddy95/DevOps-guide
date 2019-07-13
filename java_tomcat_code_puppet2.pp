#install java 
class tomcat { 
	group{'tomcat':
		name =>'tomcat',
		ensure => present,
	} 
	user{'tomcat':
		name =>'tomcat',
		ensure => present,
		groups => 'tomcat',
		require => Group['tomcat'],
	} 
	exec {'gettomcat':
		path => '/bin:/usr/sbin:/usr/bin:/sbin',
		command => 'wget http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz',
		cwd => '/tmp',
		require => Exec['install'],
	}
	exec {'extracttomcat':
		path => '/bin:/usr/sbin:/usr/bin:/sbin',
		cwd => '/tmp',
		command => 'mkdir -p /opt/tomcat && tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1',
		require => Exec['gettomcat'],
	}
	exec { 'startTomcat':
		path => '/bin:/usr/sbin:/usr/bin:/sbin',
		require => [ Exec['extracttomcat'], User['tomcat'] ] ,
		command => 'chgrp -R tomcat /opt/tomcat && /opt/tomcat/bin/startup.sh',
		cwd =>'/opt/tomcat/bin',
	}
}

class java { 
	if $::osfamily == 'Debian' {
		# Needed for update-java-alternatives
		package { 'java-common':
		ensure => present,
		notify => Exec['install'],
		}
	}
	exec { 'install':
		path => '/bin:/usr/sbin:/usr/bin:/sbin',
		command => 'add-apt-repository -y ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk',
		user => 'root',
	} 
}

class {'java':}->class{'tomcat':}

