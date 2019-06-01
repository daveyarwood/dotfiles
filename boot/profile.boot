(set-env!
  :dependencies '[[boot/new "0.5.3"]
                  [cpmcdaniel/boot-with-pom "1.0"]])

(task-options!
  push {:repo-map {:url "https://repo.clojars.org/"
                   :username (System/getenv "CLOJARS_USER")
                   :password (System/getenv "CLOJARS_PASS")}})

(require '[boot.new                 :refer (new)]
         'boot.repl
         '[cpmcdaniel.boot-with-pom :refer :all])

(deftask cider
  "Include CIDER middleware, to support editor REPL tooling."
  []
  (with-pass-thru _
    (require 'boot.repl)
    (swap! @(resolve 'boot.repl/*default-dependencies*)
           concat '[[cider/cider-nrepl "0.19.0-SNAPSHOT"]
                    [refactor-nrepl "2.4.0"]])
    (swap! @(resolve 'boot.repl/*default-middleware*)
           concat '[cider.nrepl/cider-middleware
                    refactor-nrepl.middleware/wrap-refactor])))

(deftask prepl-server
  "Start a prepl server."
  [p port PORT int "The port on which to start the prepl server."]
  (comp
    (socket-server
      :accept 'clojure.core.server/io-prepl
      :port   (or port 5555))
    (wait)))
