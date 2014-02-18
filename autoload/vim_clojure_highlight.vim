" vim-clojure-highlight

function! vim_clojure_highlight#existing_session()
	return exists('g:fireplace_nrepl_sessions') && len(g:fireplace_nrepl_sessions)
endfunction

function! vim_clojure_highlight#require()
	if !vim_clojure_highlight#existing_session() | return | endif

	if fireplace#evalparse("(find-ns 'vim-clojure-highlight)") ==# ''
		let buf = join(readfile(globpath(&runtimepath, 'autoload/vim_clojure_highlight.clj')), "\n")
		call fireplace#session_eval('(do ' . buf . ')')
	endif
endfunction

function! vim_clojure_highlight#syntax_match_references()
	if !vim_clojure_highlight#existing_session() | return | endif

	try
		call vim_clojure_highlight#require()
		execute fireplace#evalparse("(vim-clojure-highlight/ns-syntax-command '" . fireplace#ns() . ")")
	catch /./
	endtry
endfunction
