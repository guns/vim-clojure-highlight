(ns vim-clojure-highlight
  (:require [clojure.string :as string]))

(def ^:private clojure-core (find-ns 'clojure.core))

(defn- external-refs [ns]
  (remove #(= clojure-core (:ns (meta (peek %)))) (ns-refers ns)))

(defn- aliased-refs [ns]
  (reduce
    (fn [v [alias alias-ns]]
      (let [alias (str alias \/)]
        (into v (mapv #(vector (str alias (first %)) (peek %))
                      (ns-publics alias-ns)))))
    [] (ns-aliases ns)))

(defn- var-type [v]
  (let [f @v m (meta v)]
    (cond (:macro m) :macro
          (or (contains? m :arglists)
              (fn? f)
              (instance? clojure.lang.MultiFn f)) :fn
          :else :def)))

(defn- syntax-keyword-statements [seq-name->var]
  (mapv
    (fn [[type sks]]
      (let [names (string/join \space (mapv first sks))]
        (case type
          :macro (str "syntax keyword clojureMacro " names)
          :fn    (str "syntax keyword clojureFunc " names)
          :def   (str "syntax keyword clojureVariable " names))))
    (group-by (comp var-type peek) seq-name->var)))

(defn ns-syntax-command [ns]
  (->> (concat (external-refs ns)
               (aliased-refs ns))
       syntax-keyword-statements
       ;; FIXME: Escape | for execute 'syntax keyword …'
       (string/join " | ")))
