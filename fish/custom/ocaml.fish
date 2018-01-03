# OPAM configuration
source /home/dave/.opam/opam-init/init.fish > /dev/null 2> /dev/null or true

set -l opam_dir $HOME/.opam/system/bin

if test -d $opam_dir
  set -gx PATH $opam_dir $PATH
end

if which opam >/dev/null
  eval (opam config env)
end
