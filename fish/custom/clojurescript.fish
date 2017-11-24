set -l cljs_dir $CODEDIR/clojurescript

if test -d $cljs_dir
  set -gx CLOJURESCRIPT_HOME $cljs_dir
  set -gx PATH $cljs_dir/bin $PATH
end

