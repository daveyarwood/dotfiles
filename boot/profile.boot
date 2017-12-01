(set-env! :dependencies '[[boot-deps "0.1.6"]
                          [boot/new "0.5.2"]
                          ; [com.cemerick/piggieback "0.2.1"]
                          ; [org.clojure/tools.nrepl "0.2.10"]
                          ; [weasel "0.7.0"]
                          [cpmcdaniel/boot-with-pom "1.0"]])

(require 'boot.repl
         '[boot-deps                :refer (ancient)]
         '[cpmcdaniel.boot-with-pom :refer :all]
         '[boot.new                 :refer (new)])

(swap! boot.repl/*default-dependencies*
       concat '[[refactor-nrepl "2.3.1"]
                [cider/cider-nrepl "0.15.1"]])

(swap! boot.repl/*default-middleware*
       concat '[refactor-nrepl.middleware/wrap-refactor
                cider.nrepl/cider-middleware])

