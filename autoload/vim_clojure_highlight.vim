" vim-clojure-highlight

" By default spawn a Java process as necessary when opening a file
if !exists('g:vim_clojure_highlight_require_existing_session')
	let g:vim_clojure_highlight_require_existing_session = 0
endif

function! vim_clojure_highlight#existing_session()
	if !g:vim_clojure_highlight_require_existing_session ||
	\ (exists('g:fireplace_nrepl_sessions') && len(g:fireplace_nrepl_sessions))
		return 1
	endif
	return 0
endfunction

function! vim_clojure_highlight#require()
	if vim_clojure_highlight#existing_session() && fireplace#evalparse("(find-ns 'vim-clojure-highlight)") ==# ''
		let buf = join(readfile(globpath(&runtimepath, 'autoload/vim_clojure_highlight.clj')), "\n")
		call fireplace#session_eval('(do ' . buf . ')')
	endif
endfunction

function! vim_clojure_highlight#syntax_match_references()
	try
		call vim_clojure_highlight#require()
		if vim_clojure_highlight#existing_session()
			execute fireplace#evalparse("(vim-clojure-highlight/ns-syntax-command '" . fireplace#ns() . ")")
		endif
	catch /./
	endtry
endfunction
