" vim-clojure-highlight

let s:highlight_buf = join(readfile(globpath(&runtimepath, 'plugin/vim_clojure_highlight.clj')), "\n")

function! vim_clojure_highlight#require()
	if fireplace#evalparse("(find-ns 'vim-clojure-highlight)") ==# ''
		call fireplace#session_eval('(do ' . s:highlight_buf . ')')
	endif
endfunction

function! vim_clojure_highlight#highlight_references()
	try
		call vim_clojure_highlight#require()
		execute fireplace#evalparse("(vim-clojure-highlight/ns-syntax-command '" . fireplace#ns() . ")")
	catch /./
	endtry
endfunction
