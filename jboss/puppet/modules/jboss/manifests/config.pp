class jboss::config {

  define jboss_file ($name, $path, $mode = 644) {
    file { "jboss_file_$name":
      name    => $name,
      ensure  => present,
      owner   => $jboss::user,
      group   => $jboss::user,
      path    => $path,
      mode    => $mode,
      content => "jboss/$name",
    }
  }

  jboss_file { 'configure-jboss-server-ssl':
    name => "standalone.xml",
    path => "$jboss::jboss_dir/$jboss::jboss_prefix-$jboss::jboss-version/standalone/configuration/standalone.xml",
  }
}
