(ns vim-clojure-highlight)

;;;;;;;;;;;;;;;;;;;; Copied from vim-clojure-static.generate ;;;;;;;;;;;;;;;;;;;

(defn- fn-var? [v]
  (let [f @v]
    (or (when (seq (:arglists (meta v)))
          ; in clojurescript, all vars have :arglists, but it may be empty
          true)
        (fn? f)
        (instance? MultiFn f))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn clojure-core?
  "Is this var from clojure.core?"
  [var]
  (= "cljs.core" (-> var meta :ns str)))

(defn var-type [v]
  (let [f @v
        m (meta v)]
    (cond (:macro m) "clojureMacro" ;; NOTE: this doesn't actually work, sadly
          (fn-var? v) "clojureFunc"
          :else "clojureVariable")))

(defn syntax-keyword-dictionary [ns-refs]
  (->> ns-refs
       (group-by (comp var-type peek))
       (mapv (fn [[type sym->var]]
               (->> sym->var
                    (mapv (comp pr-str str first))
                    (clojure.string/join \,)
                    ((fn [values]
                       (str "'" type "': [" values "]"))))))
       (clojure.string/join \,)))

(defn ns-syntax-command [ns publics & opts]
  ; NOTE: (ns-publics) is a macro in clojurescript!
  (let [{:keys [local-vars] :or {local-vars true}} (apply hash-map opts)
        dict (syntax-keyword-dictionary
               ; NOTE: ns-refers and ns-aliases don't exist in clojurescript
               (when local-vars
                 publics))]
    ; NOTE: don't disable core keywords just yet
    (str "let b:clojure_syntax_keywords = {" dict "}")))

