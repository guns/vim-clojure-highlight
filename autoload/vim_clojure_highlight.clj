(ns vim-clojure-highlight
  (:require [clojure.string :as string]))

(def ^:private TYPE->SYNTAX-GROUP
  {:macro "clojureMacro"
   :fn "clojureFunc"
   :def "clojureVariable"})

(defn- external-refs [ns]
  (remove #(= "clojure.core" (-> % peek meta :ns str)) (ns-refers ns)))

(defn- aliased-refs [ns]
  (mapcat
    (fn [[alias alias-ns]]
      (mapv #(vector (symbol (str alias \/ (first %))) (peek %))
            (ns-publics alias-ns)))
    (ns-aliases ns)))

(defn- var-type [v]
  (let [f @v m (meta v)]
    (cond (:macro m) :macro
          (or (contains? m :arglists)
              (fn? f)
              (instance? clojure.lang.MultiFn f)) :fn
          :else :def)))

(defn- syntax-keyword-dictionary [ns-refs]
  (->> ns-refs
       (group-by (comp var-type peek))
       (mapv (fn [[type sym->vars]]
               (->> sym->vars
                    (mapv (comp pr-str str first))
                    (string/join \,)
                    (format "'%s': [%s]" (TYPE->SYNTAX-GROUP type)))))
       (string/join \,)
       (format "let b:clojure_syntax_keywords = { %s }")))

(defn ns-syntax-command [ns hi-locals?]
  (syntax-keyword-dictionary (concat (external-refs ns)
                                     (aliased-refs ns)
                                     (when hi-locals? (ns-publics ns)))))
