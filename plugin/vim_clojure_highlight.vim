" vim-clojure-highlight

let s:highlight_buf = join(readfile(globpath(&runtimepath, 'plugin/vim_clojure_highlight.clj')), "\n")

function! s:clojure_highlight_references()
	try
		if fireplace#evalparse("(find-ns 'vim-clojure-highlight)") ==# ''
			call fireplace#session_eval('(do ' . s:highlight_buf . ')')
		endif
		execute fireplace#evalparse("(vim-clojure-highlight/ns-syntax-command '" . fireplace#ns() . ")")
	catch /./
	endtry
endfunction

command! -bar ClojureHighlightReferences call s:clojure_highlight_references()

augroup vim_clojure_highlight
	autocmd!
	autocmd BufRead,BufNewFile *.clj ClojureHighlightReferences
augroup END
