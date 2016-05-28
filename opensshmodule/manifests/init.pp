# Class: opensshmodule
# ===========================
#
# Full description of class opensshmodule here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'opensshmodule':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class opensshmodule {
       case $::osfamily {
          'Debian': {
                                       $package_name = 'openssh-server'
                                       $file_path = '/etc/ssh/sshd_config'
                                       $file_source = 'puppet:///modules/opensshmodule/sshd_config'
                                       notify {"Operating system $::operatingsystem supported": }

                                 }
          'RedHat': {
                                       $package_name = 'openssh-server'
                                       $file_path = '/etc/ssh/sshd_config'
                                       $file_source = 'puppet:///modules/opensshmodule/sshd_config'
                                       notify {"Operating system $::operatingsystem supported": }

                                }
          default:  {
                                       notify {"Operating system $::operatingsystem not supported": }
				}
       }
	package { $package_name:
		ensure => installed,
	}
        file { "sshd_config":
#               alias => "openssh-conf",
                path => $file_path,
                source => $file_source,
#                owner => 'root',
#                group => 'root',
#                mode => '0644',        # UGO ( 420,400,400)
                require => Package[$package_name],
        }
        service { "sshd":
                enable => true,    #service should start on boot
                ensure => running,  #desired state of service: running
#               hasrestart => true,  #use the init script’s restart command instead of stop+start
#               hasstatus => true,   # Whether to use the init script’s status command instead of grepping the process table
                subscribe => File[  "sshd_config" ],

        }
}
