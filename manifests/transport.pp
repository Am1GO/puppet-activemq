# ==  Define: activemq::transport
#
#  Creates an ActiveMQ transport entity in the configuration file such as
#
#   <transportConnector name="stomp+nio+ssl" uri="stomp+nio+ssl://0.0.0.0:61614"/>
#   <transportConnector name="openwire" uri="tcp://0.0.0.0:61616"/>
#
# === Parameters
#
# [*name*]
#   The name of transport which defaults to the *namevar*
#
# [*uri*]
#   The uri of the transport, e.g. 'stomp+nio+ssl://0.0.0.0:61614'
#   
# [*configfile*]
#   Location of configuration file, typically '/etc/activemq/activemq.xml'
#
# === Examples
# Some transport connecters
#
#   activemq::connector{'stomp_nio_ssl':
#       name     => 'stomp+nio+ssl',
#       uri      => 'stomp+nio+ssl://0.0.0.0:61614'
#   }
#   activemq::connector{'openwire':
#       name     => 'openwire',
#       uri      => 'tcp://0.0.0.0:61616'
#   }
# 
# === Copyright
# Steve Traylen, CERN, 2014, steve.traylen@cern.ch
#
define activemq::transport ($uri, $configfile = $::activemq::configfile)
{

  validate_string($name)
  validate_string($configfile)
  validate_string($uri)

    # Populate activemq file.
  datacat_fragment{"transport_${name}":
    target  => $configfile,
    data    => { transport =>
                 [ {'name'  => $name,
                    'uri'   => $uri
                   }
                 ]
               }
   }
}

