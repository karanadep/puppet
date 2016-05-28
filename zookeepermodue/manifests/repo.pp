        # Repo Reference: http://www.cloudera.com/documentation/archive/cdh/4-x/4-2-0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html
        class zookeepermodue::repo {
               case $::osfamily {
                  'Debian': {
                                               notify {"Operating system $::operatingsystem supported": }
                                               $baseurl = 'http://archive.cloudera.com/cdh4/ubuntu/lucid/amd64/cdh'
                                         }
                  'RedHat': {
                                               notify {"Operating system $::operatingsystem supported": }
                                               $baseurl = 'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/4/'
                                        }
                  default:  {
                                               notify {"Operating system $::operatingsystem not supported": }
                                        }
               }
                yumrepo { "cloudera-repo":
                        descr => "CDH Repository",
                        baseurl => $baseurl,
                        enabled => 1,
                        gpgcheck => 0,
                  }
                  exec { "refresh-yum":
                        command => "/usr/bin/yum clean all",
                        require => Yumrepo['cloudera-repo'],
                  }
        }

