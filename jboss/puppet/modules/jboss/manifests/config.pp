class jboss::config {

  define jboss_file ($name, $path, $mode = 644) {
    file { "jboss_file_$name":
      name    => $name,
      ensure  => present,
      owner   => $jboss::user,
      group   => $jboss::user,
      path    => $path,
      mode    => $mode,
      content => template("jboss/$name.erb"),
    }
  }

  jboss_file { 'configure-jboss-server-ssl':
    name => "standalone.xml",
    path => "$jboss::jboss_dir/$jboss::jboss_prefix-$jboss::jboss-version/standalone/configuration/standalone.xml",
  }



  file { 'configure-tomcat-service':
    name    => "init.d.tomcat",
    ensure  => present,
    owner   => $tomcat::user,
    group   => $tomcat::user,
    mode    => 744,
    path    => "/etc/init.d/$tomcat::service_name",  
    content => template('tomcat/init.d.erb'),    
  }

  file { 'create-secured-webapps':
    name    => '$secured_webapps_folder',
    ensure  => 'directory',
    owner   => $tomcat::user,
    group   => $tomcat::user,
    mode    => 755,
    path    => "$tomcat::tomcat_dir/$tomcat::secured_webapps_folder"
  }

}
