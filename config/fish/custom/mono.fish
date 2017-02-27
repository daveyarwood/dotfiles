set -gx MONO_PATH /Library/Frameworks/Mono.framework/Versions

set -l current_mono_dir $MONO_PATH/Current/bin

if test -d $current_mono_dir
  set -gx PATH $current_mono_dir $PATH
end

