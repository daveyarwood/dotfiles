(set-env! :dependencies '[[boot-deps "0.1.6"]
                          ; [com.cemerick/piggieback "0.2.1"]
                          ; [org.clojure/tools.nrepl "0.2.10"]
                          ; [weasel "0.7.0"]
                          [cpmcdaniel/boot-with-pom "1.0"]])

(require 'boot.repl
         '[boot-deps :refer (ancient)]
         '[cpmcdaniel.boot-with-pom :refer :all])

; (swap! boot.repl/*default-dependencies*
;       concat '[[lein-light-nrepl "0.1.0"]
;                [org.clojure/clojurescript "0.0-2511"]])

; (swap! boot.repl/*default-middleware*
;       conj 'lighttable.nrepl.handler/lighttable-ops)

(swap! boot.repl/*default-dependencies*
       concat '[[cider/cider-nrepl "0.9.1"]])

(swap! boot.repl/*default-middleware*
       conj 'cider.nrepl/cider-middleware)

; (swap! boot.repl/*default-middleware*
;       conj 'cemerick.piggieback/wrap-cljs-repl)

