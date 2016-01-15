# this path is OSX specific.
# TODO: come up with some way to have different paths on different hosts
set -gx ANDROID_HOME $HOME/Library/Android/sdk

# wrappers for android dev programs
function android
	eval $ANDROID_HOME/tools/android $argv;
end

function adb
	eval $ANDROID_HOME/platform-tools/adb $argv;
end

function android-emulator
	eval $ANDROID_HOME/tools/emulator -avd Nexus_5_API_23_x86 $argv;
end

function android-emu
	android-emulator $argv;
end

