" vim-clojure-highlight

let s:highlight_buf = join(readfile(globpath(&runtimepath, 'plugin/vim_clojure_highlight.clj')), "\n")

function! s:clojure_highlight_vars()
	if fireplace#evalparse("(find-ns 'vim-clojure-highlight)") ==# ''
		call fireplace#evalparse('(do ' . s:highlight_buf . ')')
	endif

	execute fireplace#evalparse("(vim-clojure-highlight/ns-syntax-command '" . fireplace#ns() . ")")
endfunction

command! -bar ClojureHighlightVars call s:clojure_highlight_vars()
