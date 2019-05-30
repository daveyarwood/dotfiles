(set-env!
  :dependencies '[[boot/new "0.5.3"]
                  [cpmcdaniel/boot-with-pom "1.0"]])

(task-options!
  push {:repo-map {:url "https://repo.clojars.org/"
                   :username (System/getenv "CLOJARS_USER")
                   :password (System/getenv "CLOJARS_PASS")}})

(require '[boot.new                 :refer (new)]
         'boot.repl
         '[boot.util                :as    util]
         '[clojure.core.server      :as    server]
         '[cpmcdaniel.boot-with-pom :refer :all])

(import '[java.net ConnectException Socket])

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

(defn port-listening?
  [host port]
  (try
    (.close (Socket. host port))
    true
    (catch ConnectException _ false)))

(deftask prepl
  "Start a prepl server."
  [p port PORT int "The port on which to start the prepl server."]
  (comp
    (with-pass-thru _
      (let [host "localhost"
            port (or port 5555)]
        (when (port-listening? host port)
          (util/fail
            "Unable to start prepl on port %d; that port is in use."
            port)
          (System/exit 1))
        (util/info "Starting prepl on port %d...\n" port)
        (server/start-server {:accept  `server/io-prepl
                              :address host
                              :port    port
                              :name    "Dave's amazing prepl"})))
    (wait)))
