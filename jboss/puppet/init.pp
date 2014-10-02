class { '::jboss::jboss': 
  server_port              => '8005',
  http_port                => '8080',
  ajp_port                 => '8009',
  redirect_port            => '8443',
  secured_http_port        => '8180',
  user                     => 'jboss',
  password                 => '$6$ClvDd5Yc$B2yUMzKKyg8MUxQeRNtdOWewdm6opE9zmt8R6ez2/kaPESCWdnB3OlchXNXsmdgXtPCrJb6WcOcENUfbYZXQ2.',
}
