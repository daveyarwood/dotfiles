(set-env! :dependencies '[[boot-deps "0.1.4"]])

(require 'boot.repl
         '[boot-deps :refer (ancient)])

(swap! boot.repl/*default-dependencies*
      concat '[[lein-light-nrepl "0.1.0"]
               [org.clojure/clojurescript "0.0-2511"]])

(swap! boot.repl/*default-middleware*
      conj 'lighttable.nrepl.handler/lighttable-ops)