" vim-clojure-highlight

function! s:session_exists()
	return exists('g:fireplace_nrepl_sessions') && len(g:fireplace_nrepl_sessions)
endfunction

function! s:require()
	if fireplace#evalparse("(find-ns 'vim-clojure-highlight)") ==# ''
		let buf = join(readfile(globpath(&runtimepath, 'autoload/vim_clojure_highlight.clj')), "\n")
		call fireplace#session_eval('(do ' . buf . ')')
	endif
endfunction

function! vim_clojure_highlight#syntax_match_references()
	if !s:session_exists() | return | endif

	try
		call s:require()
		execute fireplace#evalparse("(vim-clojure-highlight/ns-syntax-command '" . fireplace#ns() . ")")
	catch /./
	endtry
endfunction
