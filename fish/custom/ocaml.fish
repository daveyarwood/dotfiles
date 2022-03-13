# OPAM configuration
source /home/dave/.opam/opam-init/init.fish > /dev/null 2> /dev/null or true

add-dirs-to-path $HOME/.opam/system/bin

if which opam >/dev/null
  eval (opam config env)
end
