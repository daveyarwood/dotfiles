# this allows me to use `$(boot2docker ip)` inside commands without
# "The VM's Host only interface IP address is:" printing to STDOUT
function docker-ip
  boot2docker ip ^ /dev/null
end

# sets DOCKER_HOST, DOCKER_MACHINE_NAME, DOCKER_TLS_VERIFY, DOCKER_CERT_PATH
# if the default Docker VM (the only one I use) is running
if [ (docker-machine status default) = 'Running' ]
  eval (docker-machine env default)
end
