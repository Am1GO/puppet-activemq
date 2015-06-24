# == Define: activemq::network
#
# Creates networkConnector entity in an activemq.xml file for configuration
# of broker <-> broker connections.
#
#  <networkConnector
#               name="broker1.example.org-broker2.example.org-topics"
#               uri="static:(tcp://broker2.example.org:61616)"
#               userName="activemq"
#               password="xyz"
#               duplex="false"
#               decreaseNetworkConsumerPriority="true"
#               networkTTL="2"
#               dynamicOnly="true"
#               conduitSubscriptions="true">
#               <excludedDestinations>
#                       <topic physicalName=">" />
#               </excludedDestinations>
#  </networkConnector>
#
# === Parameters
#
# [*title*]
#   This is the name of the networkConnector and is defaulted to be the
#   the "namevar*.
#
# [*uri*]
#   The uri of connector, e.g 'static:(tcp://broker2.example.org:61616)'
#
# [*username*]
#   The username to use for the connector.
#
# [*password*]
#   The password to use for the username
#
# [*duplex*]
#   A boolean defaulting to false , if true duplex attribute will 'true'.
#
# [*decreaseNetworkConsumerPriority*]
#   A boolean defaulting to true, if true decreaseNetworkConsumerPriority attribute will
#   be set.
#
# [*networkTTL*]
#   Defaults to 2, is the *networkTTL* if the networkConnecter.
#
# [*dynamicOnly*]
#   A boolean defaulting to true. Sets the attribute dynamicOnly to 'true' or 'false'.
#
# [*conduitSubscriptions*]
#   A boolean defaulting to true. Sets the attribute conduitSubscriptions to 'true' or 'false'.
#
# [*excludedDestinationsType*]
#   Should be set to 'queue' or 'topic' and allows excludeDestinations to be set.
#
# [*excludedDestinationsPath*]
#   The path of the queue or topic to be excluded.
#
# === Examples
# Two network connecters, uniplex, one for queues and one for topics.
#   activemq::network{"broker1-broker2-topics":
#       uri                             => "static:(tcp://broker2.example.org:61616)",
#       username                        => 'activemq',
#       password                        => 'xyz',
#       duplex                          => false,
#       decreaseNetworkConsumerPriority => true,
#       networkTTL                      => '2',
#       dynamicOnly                     => true,
#       conduitSubscriptions            => true,
#       excludedDestinationsType        => 'topic',
#       excludedDestinationsPath        => '>'
#   }
#   activemq::network{"broker1-broker2-queues":
#       uri                             => "static:(tcp://broker2.example.org:61616)",
#       username                        => 'activemq',
#       password                        => 'xyz',
#       duplex                          => false,
#       decreaseNetworkConsumerPriority => true,
#       networkTTL                      => '2',
#       dynamicOnly                     => true,
#       conduitSubscriptions            => false,
#       excludedDestinationsType        => 'queue',
#       excludedDestinationsPath        => '>'
#   }
#
# === Copyright
# Steve Traylen, CERN, 2014 , steve.traylen@cern.ch
#
define activemq::network ($excludedDestinationsType,$excludedDestinationsPath,$uri,$username,
  $password,$configfile = $::activemq::configfile,
  $duplex = false,
  $decreaseNetworkConsumerPriority = true,
  $networkTTL = '2',
  $dynamicOnly = true,
  $conduitSubscriptions = true
)
{

  validate_string($name)
  validate_string($configfile)
  validate_string($uri)
  validate_string($username)
  validate_string($password)
  validate_bool($duplex)
  validate_bool($decreaseNetworkConsumerPriority)
  validate_string($networkTTL)
  validate_bool($dynamicOnly)
  validate_bool($conduitSubscriptions)
  validate_re($excludedDestinationsType,['^topic','^queue'],'$excludedDestinationsType should be queue or topic')
  validate_string($excludedDestinationsPath)

  # Populate activemq file.
  $duplex_value  = $duplex ? {
    true  => 'true',
    false => 'false'
  }
  $decreaseNetworkConsumerPriority_value  = $decreaseNetworkConsumerPriority ? {
    true  => 'true',
    false => 'false'
  }
  $dynamicOnly_value  = $dynamicOnly ? {
    true  => 'true',
    false => 'false'
  }
  $conduitSubscriptions_value  = $conduitSubscriptions ? {
    true  => 'true',
    false => 'false'
  }

  datacat_fragment{"network_${name}":
    target  => $configfile,
    data    => { network =>
                 [ {'name'                            => $name,
                    'uri'                             => $uri,
                    'username'                        => $username,
                    'password'                        => $password,
                    'duplex'                          => $duplex_value,
                    'decreaseNetworkConsumerPriority' => $decreaseNetworkConsumerPriority_value,
                    'networkTTL'                      => $networkTTL,
                    'dynamicOnly'                     => $dynamicOnly_value,
                    'conduitSubscriptions'            => $conduitSubscriptions_value,
                    'excludedDestinationsType'        => $excludedDestinationsType,
                    'excludedDestinationsPath'        => $excludedDestinationsPath
                   }
                 ]
               }
  }
}

