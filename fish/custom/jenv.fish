# I have no idea what is setting JAVA_HOME (it's nothing in my dotfiles...), but
# at any rate, `jenv doctor` says that it could interfere with scripts using the
# Java version set by jenv, if the scripts use JAVA_HOME.
set -e JAVA_HOME

set -gx PATH $HOME/.jenv/bin $PATH
command jenv rehash 2>/dev/null
set -gx PATH $HOME/.jenv/shims $PATH

function jenv
  set cmd $argv[1]
  set arg ""
  if test (count $argv) -gt 1
    set arg $argv[2..-1]
  end

  switch "$cmd"
    case enable-plugin rehash shell shell-options
        set script (jenv "sh-$cmd" "$arg")
        eval $script
    case '*'
        command jenv $cmd $arg
    end
end

