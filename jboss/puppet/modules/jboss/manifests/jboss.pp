class jboss::jboss (  
              $server_port='8005',
              $http_port='8080',
		   $ajp_port='8009',
              $redirect_port='8443',
              $user='jboss',
              $password='$6$4VOKuIDtu9Q$7ITuz8TWfQHlfThNQ0qyrCkSLai3MZhj7HiuILZ1GCLp1FRarZq93ieW/j0CsllRKmjAppS1WPzJkg6GnyQCe0',
              $jboss_users='',
              $ip=$ipaddress_eth0,
              $secured_http_port='8180',
              ) { 

  notify {"server_port = $server_port":}
  notify {"http_port = $http_port":}
  notify {"ajp_port = $ajp_port":}
  notify {"redirect_port = $redirect_port":}
  notify {"user = $user":}
   
  $home = "/home/$user"
  $jboss_version = "7.1.1.Final"
  $jboss_prefix = 'jboss-as'
  $jboss_dir = "/usr/share/"
  notify {"home = $home":}

  Exec {
    path => $path,
    logoutput => true,
  }

  #################
  # User creation #
  #################

  user { 'jboss_user':
     name       => $user,
     password   => $password,
     ensure     => 'present',
     managehome => 'true',
     home       => $home,
     shell      => '/bin/bash',
  }

  #####################
  # Install JDK 1.7   #
  #####################
  package { 'wget': 
      ensure => present,
  }

  package { 'jdk7':
    ensure => present,
    name   => "openjdk-7-jdk",
  }

  exec { 'chmod_cacerts':
      command => "chmod a+rw /etc/ssl/certs/java/cacerts",
      onlyif  => "test true",
      require => Package['jdk7'], 
  }

  #####################
  # Install jboss    #
  #####################
  exec { 'download_jboss':
      command => "wget 
http://download.jboss.org/jbossas/7.1/$jboss_prefix-$jboss_version/$jboss_prefix-$jboss_version.zip,
      cwd     => "/tmp",
      user    => $user,
      creates => "/tmp/$jboss_prefix-$jboss_version.zip",
      require => [
        User['jboss_user'],
        Package['wget'],
      ],
  }

  exec { 'unzip_jboss':
      command => "sudo unzip /tmp/$jboss_prefix-$jboss_version.zip -d /usr/share",
      cwd     => $home,
      user    => $user,
      creates => $jboss_dir,
      require => [
        User['jboss_user'],
        Exec['download_jboss'],
      ],
  }


exec { 'chown_directory':
      command => "sudo chown -fR $user.$user $jboss_dir/$jboss_prefix-$jobss_version/",
      onlyif  => "test true",
      require => Package['jdk7'], 
  }

  ###################
  # generate  a self signed ssl certificate
  ###################	
include ssl
ssl::self_signed_certficate { $::fqdn:
  common_name      => $::fqdn,
  email_address    => 'root@example.de',
  country          => 'FR',
  organization     => 'Example GmbH',
  days             => 730,
  directory        => '$jboss_dir/$jboss_prefix-$jboss_version/standalone/configuration/'
}

  ###################
  # Config  jboss  #
  ###################
  class { '::jboss::config':
    require => Exec['unzip_jboss'],
  }  

  ###################
  # Launch  jboss  #
  ###################
exec { 'launch_jboss':
      command => "./standalone.sh -b 0.0.0.0",
      cwd     => $jboss_dir/$jboss_prefix-$jboss_version/bin/,
      user    => $user,
      require => [
        User['jboss_user'],
        Exec['download_jboss'],
      ],
  }

}
