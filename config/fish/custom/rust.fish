set -l cargo_dir $HOME/.cargo/bin

if test -d $cargo_dir
  set -gx PATH $cargo_dir $PATH
end

