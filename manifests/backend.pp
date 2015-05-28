# == Define: powerdns::backend

define powerdns::backend {
  validate_string($name)

  # Construct the backend class name.
  $backend = "::powerdns::backend::${name}"

  # If the backend doesn't exist, it's not supported.
  if defined($backend) == false {
    fail("This module does not support the ${name} backend for PowerDNS!")
  }

  # Ensure the backend has been configured in ::powerdns.
  if ! $name in $::powerdns::backends {
    fail("You must add ${name} to the list of configured backends!")
  }

  # Ensure PowerDNS is installed before the backend is evaluated.
  Class['::powerdns::install'] -> Class[$backend]

  # Ensure the backend notifies PowerDNS when things change.
  Class[$backend] ~> Class['::powerdns::service']

  # Evaluate the backend.
  include $backend
}
