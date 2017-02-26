set -gx PATH $HOME/.jenv/bin $PATH
command jenv rehash 2>/dev/null
set -gx PATH $HOME/.jenv/shims $PATH

function jenv
  set cmd $argv[1]
  set arg ""
  if test (count $argv) -gt 1
    # Great... fish first array index is ... 1 !
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

# Required in order to build Alda with support for JDK7
# NOTE: this is machine-specific.
# TODO: come up with some way to have different paths on different hosts
set -gx JDK7_BOOTCLASSPATH /Library/Java/JavaVirtualMachines/jdk1.7.0_71.jdk/Contents/Home/jre/lib/rt.jar
