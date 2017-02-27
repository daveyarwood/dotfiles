set -l opam_dir $HOME/.opam/system/bin

if test -d $opam_dir
  set -gx PATH $opam_dir $PATH
end

