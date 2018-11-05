(set-env! :dependencies '[[boot/new "0.5.2"]
                          ; [com.cemerick/piggieback "0.2.1"]
                          ; [org.clojure/tools.nrepl "0.2.10"]
                          ; [weasel "0.7.0"]
                          [cpmcdaniel/boot-with-pom "1.0"]])

(require 'boot.repl
         '[cpmcdaniel.boot-with-pom :refer :all]
         '[boot.new                 :refer (new)])

(swap! boot.repl/*default-dependencies*
       concat '[[refactor-nrepl "2.4.0"]
                [cider/cider-nrepl "0.18.0"]])

(swap! boot.repl/*default-middleware*
       concat '[refactor-nrepl.middleware/wrap-refactor
                cider.nrepl/cider-middleware])

