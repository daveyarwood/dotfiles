# Sets $DOCKER_IP and adds a 'dockerhost' entry in /etc/hosts.
function update-dockerhost
  # clear existing dockerhost entry from /etc/hosts
	sudo sed -i '' '/[[:space:]]dockerhost$/d' /etc/hosts

	# get ip of running machine
	set -gx DOCKER_IP (echo $DOCKER_HOST | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

	# update /etc/hosts with docker machine ip
  if not [ "$DOCKER_IP" = '' ]
    sudo fish -c "echo \"$DOCKER_IP dockerhost\" >> /etc/hosts" ^ /dev/null
  end
end

# Sets DOCKER_HOST, DOCKER_MACHINE_NAME, DOCKER_TLS_VERIFY, DOCKER_CERT_PATH
# if the default Docker VM (the only one I use) is running.
if [ (docker-machine status default) = 'Running' ]
  eval (docker-machine env default)
end

function docker-clean
  # make sure that exited containers are deleted
  docker rm -v (docker ps -a -q -f status=exited)
  # remove dangling images
  docker rmi (docker images -f "dangling=true" -q)
  # remove untagged images
  docker rmi (docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3) -f
end
