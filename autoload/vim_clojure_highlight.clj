(ns vim-clojure-highlight
  (:require [clojure.set :as set]
            [clojure.string :as string])
  (:import (clojure.lang MultiFn)))

;;;;;;;;;;;;;;;;;;;; Copied from vim-clojure-static.generate ;;;;;;;;;;;;;;;;;;;

(defn- fn-var? [v]
  (let [f @v]
    (or (contains? (meta v) :arglists)
        (fn? f)
        (instance? MultiFn f))))

(def special-forms
  "http://clojure.org/special_forms"
  '#{def if do let quote var fn loop recur throw try catch finally
     monitor-enter monitor-exit . new set!})

(def keyword-groups
  "Special forms, constants, and every public var in clojure.core keyed by
   syntax group name."
  (let [exceptions '#{throw try catch finally}
        builtins {"clojureConstant" '#{nil}
                  "clojureBoolean" '#{true false}
                  "clojureSpecial" (apply disj special-forms exceptions)
                  "clojureException" exceptions
                  "clojureCond" '#{case cond cond-> cond->> condp if-let
                                   if-not if-some when when-first when-let
                                   when-not when-some}
                  ;; Imperative looping constructs (not sequence functions)
                  "clojureRepeat" '#{doseq dotimes while}}
        coresyms (set/difference (set (keys (ns-publics 'clojure.core)))
                                 (set (mapcat peek builtins)))
        group-preds [["clojureDefine" #(re-seq #"\Adef(?!ault)" (str %))]
                     ["clojureMacro" #(:macro (meta (ns-resolve 'clojure.core %)))]
                     ["clojureFunc" #(fn-var? (ns-resolve 'clojure.core %))]
                     ["clojureVariable" identity]]]
    (first
      (reduce
        (fn [[m syms] [group pred]]
          (let [group-syms (set (filterv pred syms))]
            [(assoc m group group-syms)
             (set/difference syms group-syms)]))
        [builtins coresyms] group-preds))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def core-symbol->syntax-group
  "A map of symbols from clojure.core mapped to syntax group name."
  (reduce
    (fn [m [group syms]]
      (reduce
        (fn [m sym]
          (assoc m sym group))
        m syms))
    {} keyword-groups))

(defn clojure-core?
  "Is this var from clojure.core?"
  [var]
  (= "clojure.core" (-> var meta :ns str)))

(defn aliased-refers [ns]
  (mapcat
    (fn [[alias alias-ns]]
      (mapv #(vector (symbol (str alias \/ (first %))) (peek %))
            (ns-publics alias-ns)))
    (ns-aliases ns)))

(defn all-ns-refers []
  (mapcat
    (fn [current-ns]
      (mapv
        #(vector (symbol (str current-ns \/ (first %))) (peek %))
        (ns-publics current-ns)))
    (map #(symbol (str %)) (all-ns))))

(defn var-type [v]
  (let [f @v m (meta v)]
    (cond (clojure-core? v) (core-symbol->syntax-group (:name m))
          (:macro m) "clojureMacro"
          (fn-var? v) "clojureFunc"
          :else "clojureVariable")))

(defn syntax-keyword-dictionary [ns-refs]
  (->> ns-refs
       (group-by (comp var-type peek))
       (mapv (fn [[type sym->var]]
               (->> sym->var
                    (mapv (comp pr-str str first))
                    (string/join \,)
                    (format "'%s': [%s]" type))))
       (string/join \,)))

(defn ns-syntax-command [ns & opts]
  (let [{:keys [local-vars] :or {local-vars true}} (apply hash-map opts)
        dict (syntax-keyword-dictionary (concat (ns-refers ns)
                                                (all-ns-refers)
                                                (aliased-refers ns)
                                                (when local-vars (ns-publics ns))))]
    (str "let b:clojure_syntax_without_core_keywords = 1 | let b:clojure_syntax_keywords = {" dict "}")))
