# Class: datadog_agent::ubuntu
#
# This class contains the DataDog agent installation mechanism for Ubuntu
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#

class datadog_agent::ubuntu(
  $apt_key = '935F5A436A5A6E8788F0765B226AE980C7A7DA52',
  $agent_version = 'latest',
  $other_keys = ['C7A7DA52']
) {
  $packagelist = ['datadog-agent', ]

  if !defined(Class['apt']) {
    class { 'apt': }
  }

  apt::source { 'datadog.list':
    location    => 'http://apt.datadoghq.com/',
    release     => 'stable',
    repos       => 'main',
    key         => {
      'id'     => $apt_key,
      'server' => 'hkp://keyserver.ubuntu.com:80',
    },
    include_src => false,
  } ->
  package {
    $packagelist:
      ensure  => latest;
  }

  service { 'datadog-agent':
    ensure    => $::datadog_agent::service_ensure,
    enable    => $::datadog_agent::service_enable,
    hasstatus => false,
    pattern   => 'dd-agent',
    require   => Package['datadog-agent'],
  }
}
