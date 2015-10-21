# this allows me to use `$(boot2docker ip)` inside commands without
# "The VM's Host only interface IP address is:" printing to STDOUT
function docker-ip
  boot2docker ip ^ /dev/null
end

