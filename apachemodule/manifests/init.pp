# Class: apachemodule
# ===========================
#
# Full description of class apachemodule here.
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
#    class { 'apachemodule':
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
class apachemodule {
       case $::osfamily {
          'Debian': {
                                       $package_name = 'apache2'
                                       $file_path = '/etc/apache2/apache2.conf'
                                       $file_source = 'puppet:///modules/apachemodule/apache2_conf'
				       $service_name = 'apache2'
                                       $file_name = 'apache_config'
                                       notify {"Operating system $::operatingsystem supported and installed apache at ${file_path}": }

                                 }
          'RedHat': {
                                       $package_name = 'httpd'
                                       $file_path = '/etc/httpd/conf/httpd.conf'
                                       $file_source = 'puppet:///modules/apachemodule/httpd_conf'
                                       $service_name = 'httpd'
                                       $file_name = 'apache_config'
                                       notify {"Operating system $::operatingsystem supported and installed apache at ${file_path}": }

                                }
          default:  {
                                       notify {"Operating system $::operatingsystem not supported": }
                                }
       }
        package { $package_name:
                ensure => installed,
        }
        file { $file_name:
#               alias => "apache-conf",
                path => $file_path,
                source => $file_source,
                #owner => 'root',
                #group => 'root',
                #mode => '0644',        # UGO ( 420,400,400)
                require => Package[ $package_name ],
        }
        service { $service_name:
                enable => true,    #service should start on boot
                ensure => running,  #desired state of service: running
                hasrestart => true,  #use the init script’s restart command instead of stop+start
                hasstatus => true,   # Whether to use the init script’s status command instead of grepping the process table
                subscribe => File[ $file_name ],

        }

}
