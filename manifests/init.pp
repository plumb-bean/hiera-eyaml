class hieraeyaml {
  
  package { 'hiera-eyaml':
    ensure   => installed,
    provider => 'pe_puppetserver_gem',
  }

  file { '/etc/puppetlabs/puppet/environments/production/secure':
    ensure => directory,
  }

  exec { 'create keys':
    command => '/opt/puppet/bin/eyaml createkeys',
    creates => '/etc/puppetlabs/puppet/environments/production/secure/keys/private_key.pkcs7.pem'
    require => Package['hiera-yaml'],
  }

  file { '/etc/puppetlabs/puppet/environments/production/secure/keys':
    ensure  => directory,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0500',
    require => Exec['create keys'],
  }

  file { '/etc/puppetlabs/puppet/environments/production/secure/keys/private_key.pkcs7.pem'
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0400',
    require => Exec['create keys'],
  }

  file { '/etc/puppetlabs/puppet/environments/production/secure/keys/public_key.pkcs7.pem'
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0400',
    require => Exec['create keys'],
  }

  file { '~/.eyaml':
    ensure => directory,
  }

  file { '~/.eyaml/config.yaml':
    ensure => file,
    source => 'puppet:///modules/hiera_eyaml/config.yaml',
  }

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure => file,
    source => 'puppet:///modules/hiera_eyaml/hiera.yaml.',
  }


}
