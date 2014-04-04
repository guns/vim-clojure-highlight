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

" Pass zero explicitly to prevent highlighting local vars
function! vim_clojure_highlight#syntax_match_references(...)
	if !s:session_exists() | return | endif

	try
		call s:require()

		let ns = "'" . fireplace#ns()
		let opts = (a:0 > 0 && !a:1) ? ' :local-vars false' : ''

		execute fireplace#evalparse("(vim-clojure-highlight/ns-syntax-command " . ns . opts . ")")
		let &syntax = &syntax
	catch /./
	endtry
endfunction

" vim:noet:sw=8:ts=8
