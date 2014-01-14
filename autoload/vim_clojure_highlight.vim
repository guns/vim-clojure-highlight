" vim-clojure-highlight

function! vim_clojure_highlight#require()
	if fireplace#evalparse("(find-ns 'vim-clojure-highlight)") ==# ''
		let buf = join(readfile(globpath(&runtimepath, 'autoload/vim_clojure_highlight.clj')), "\n")
		call fireplace#session_eval('(do ' . buf . ')')
	endif
endfunction

function! vim_clojure_highlight#syntax_match_references()
	try
		call vim_clojure_highlight#require()
		execute fireplace#evalparse("(vim-clojure-highlight/ns-syntax-command '" . fireplace#ns() . ")")
	catch /./
	endtry
endfunction
