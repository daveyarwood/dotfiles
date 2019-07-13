(ns dave.prepl-server
  (:require [clojure.core.server :as server]
            [clojure.java.io     :as io])
  (:import [java.net ConnectException Socket]))

(defn port-listening?
  [host port]
  (try
    (.close (Socket. host port))
    true
    (catch ConnectException _ false)))

(defn- log
  [& args]
  (println (apply format args)))

(defn start-prepl-server!
  [port]
  (let [host "localhost"]
    (when (port-listening? host port)
      (log "Unable to start prepl server on port %d; that port is in use." port)
      (System/exit 1))
    (let [socket         (server/start-server
                           {:accept `server/io-prepl
                            :address host
                            :port    port
                            :name    "Dave's amazing prepl server"})
          effective-port (.getLocalPort socket)]
      (doto (io/file ".socket-port")
        .deleteOnExit
        (spit effective-port))
      (log "Started prepl server on port %d." effective-port))

    ;; Wait until process is interrupted.
    @(promise)))

(defn -main
  [& [port]]
  (start-prepl-server! (if port (Integer/parseInt port) 0)))
