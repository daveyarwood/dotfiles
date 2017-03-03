set -l rebar_dir $HOME/.cache/rebar3/bin

if test -d $rebar_dir
  set -gx PATH $rebar_dir $PATH
end

