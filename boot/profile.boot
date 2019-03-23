(set-env!
  :dependencies '[[boot/new "0.5.3"]
                  [cpmcdaniel/boot-with-pom "1.0"]])

(task-options!
  push {:repo-map {:url "https://repo.clojars.org/"
                   :username (System/getenv "CLOJARS_USER")
                   :password (System/getenv "CLOJARS_PASS")}})

(require 'boot.repl
         '[cpmcdaniel.boot-with-pom :refer :all]
         '[boot.new                 :refer (new)])

;; (swap! boot.repl/*default-dependencies*
;;        concat '[[refactor-nrepl "2.4.0"]
;;                 [cider/cider-nrepl "0.19.0-SNAPSHOT"]])

;; (swap! boot.repl/*default-middleware*
;;        concat '[refactor-nrepl.middleware/wrap-refactor
;;                 cider.nrepl/cider-middleware])

