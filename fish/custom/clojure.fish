set -gx BOOT_HOME $HOME/.config/boot
set -gx BOOT_JVM_OPTIONS '-client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xmx2g -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xverify:none'
set -gx BOOT_EMIT_TARGET no
