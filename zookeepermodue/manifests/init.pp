# Class: zookeepermodue
# ===========================
#
# Full description of class zookeepermodue here.
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
#    class { 'zookeepermodue':
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
# packages: 
# zookeeper-server #zookeeper-server package required for any machine in the ZooKeeper ensemble
# zookeeper #zookeeper package required for any machine connecting to ZooKeeper
class zookeepermodue {	

	class client {
                require zookeepermodue::repo
                package { "zookeeper":
                      ensure => installed,
                      require => Yumrepo["cloudera-repo"],
                }
        }

        #port 2181 is used by ZooKeeper clients to connect to the ZooKeeper servers,
        # port 2888 is used by peer ZooKeeper servers to communicate with each other,
        # and port 3888 is used for leader election.
        class server (
                $myid           = undef,
                $ensemble       =  ['localhost:2888:3888']
        ){
                require zookeepermodule::repo
                $package_name = "zookeeper-server"

                package { $package_name:
                        ensure  => installed,
                        require => Yumrepo["cloudera-repo"]
                }

                file { "zookeeper-conf":
                        path    => "/etc/zookeeper/conf/zoo.cfg",
                        content => template("zookeeper/zoo.cfg.erb"),
                        require => Package[$package_name],
                }

                # The contents of this file would be just the numeral 1 on zkserver1.cloudwick.com,
                # numeral 2 on zkserver2.cloudwick.com, and numeral 3 onzkserver3.cloudwick.com
                file { "zookeeper-myid":
                        path => "/var/lib/zookeeper/myid",
                        content => inline_template("<%= @myid %>"),
                        require => Package[$package_name],
                }


                service { "zookeeper-server":
                        enable => true,    #service should start on boot
                        ensure => running,  #desired state of service: running
                        hasrestart => true,  #use the init script’s restart command instead of stop+start
                        hasstatus => true,   # Whether to use the init script’s status command instead of grepping the process table
                        require => [ Package["zookeeper-server"] ],
                        subscribe => [ File[
                                            "zookeeper-conf",
                                            "zookeeper-myid",
                                            ]
                                      ]
                }
        }

}
