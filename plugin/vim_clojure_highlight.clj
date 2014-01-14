(ns vim-clojure-highlight
  (:require [clojure.string :as string]))

(defrecord NsReference [name var])

(defn external-refs [ns]
  (->> (ns-refers ns)
       (remove #(contains? '#{clojure.core cljs.core}
                           (ns-name (:ns (meta (peek %))))))
       (mapv #(NsReference. (str (first %)) (peek %)))))

(defn aliased-refs [ns]
  (reduce
    (fn [v [alias alias-ns]]
      (let [alias (str alias \/)]
        (into v (mapv #(NsReference. (str alias (first %)) (peek %))
                      (ns-publics alias-ns)))))
    [] (ns-aliases ns)))

(defn var-type [v]
  (let [f @v m (meta v)]
    (cond (:macro m) :macro
          (or (contains? m :arglists)
              (fn? f)
              (instance? clojure.lang.MultiFn f)) :fn
          :else :def)))

(defn syntax-keyword-statements [syntax-keywords]
  (mapv
    (fn [[type sks]]
      (let [names (string/join \space (mapv :name sks))]
        (case type
          :macro (str "syntax keyword clojureMacro " names)
          :fn    (str "syntax keyword clojureFunc " names)
          :def   (str "syntax keyword clojureVariable " names))))
    (group-by (comp var-type :var) syntax-keywords)))

(defn ns-syntax-command [ns]
  (->> (concat (external-refs ns)
               (aliased-refs ns))
       syntax-keyword-statements
       ;; FIXME: Escape | for execute 'syntax keyword …'
       (string/join " | ")))
