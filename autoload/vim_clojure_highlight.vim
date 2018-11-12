" vim-clojure-highlight

function! s:is_cljs()
	return expand('%:e') == 'cljs'
endfunction

function! s:session_exists()
	return exists('g:fireplace_nrepl_sessions') && len(g:fireplace_nrepl_sessions)
endfunction

function! s:evalparse(cmd)
	if !s:is_cljs()
		return fireplace#evalparse(a:cmd)
	endif

	" NOTE: evalparse doesn't seem to work in cljs
	" due to the {'session': 0} opts (weird).
	let cmd = printf(g:fireplace#reader, a:cmd)
	let resp = fireplace#session_eval(cmd)
	if !empty(resp)
		return eval(resp)
	else
		return ''
	endif
endfunction

function! s:require(force)
	if !a:force && s:evalparse("(nil? (find-ns 'vim-clojure-highlight))") == 0
		echom "Loaded!"
		return 0
	endif

	echom "Loading vim-clojure-highlight"
	let ext = expand('%:e')
	if ext != 'cljs' && ext != 'clj'
		let ext = 'clj'
	endif
	let file = globpath(&runtimepath, 'autoload/vim_clojure_highlight.' . ext)
	let buf = join(readfile(file), "\n")
	if s:is_cljs()
		call fireplace#session_eval('(ns vim-clojure-highlight) (do ' . buf . ')')
	else
		call fireplace#session_eval('(do ' . buf . ')')
	endif
	return 1
endfunction

" temporary, to force-reload the vim-clojure-highlight ns
function! vim_clojure_highlight#require()
	return s:require(1)
endfunction

" Pass zero explicitly to prevent highlighting local vars
function! vim_clojure_highlight#syntax_match_references(...)
	if !s:session_exists() | return | endif

	try
		echom "require(0)"
		call s:require(0)

		let ns = "'" . fireplace#ns()
		let opts = (a:0 > 0 && !a:1) ? ' :local-vars false' : ''
		if s:is_cljs()
			let ns = ns . ' (ns-publics ' . ns . ')'
		endif
		echom "run highlight"
		execute s:evalparse("(vim-clojure-highlight/ns-syntax-command " . ns . opts . ")")

		let &syntax = &syntax
	catch /./
	endtry
endfunction

" vim:noet:sw=8:ts=8
