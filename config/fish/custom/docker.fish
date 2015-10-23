# this allows me to use `$(boot2docker ip)` inside commands without
# "The VM's Host only interface IP address is:" printing to STDOUT
function docker-ip
  boot2docker ip ^ /dev/null
end

# I don't remember how I got these set up. I was following a guide I found on
# getting an OS X environment set up for Docker development.
# TODO: look up how I got these variables, set them dynamically by running
# the commands instead of having them hard-coded.
set -gx DOCKER_CERT_PATH $HOME/.boot2docker/certs/boot2docker-vm
set -gx DOCKER_HOST tcp://192.168.59.103:2376
set -gx DOCKER_TLS_VERIFY 1
