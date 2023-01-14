" vim-clojure-highlight

function! s:session_exists(platform)
	try
		let msg = a:platform.Query("nil")
		return 1
	catch /Fireplace: no live REPL connection/
		return 0
	endtry
endfunction


function! s:require(platform)
	let msg = a:platform.Query("(find-ns 'vim-clojure-highlight)")
	call fireplace#wait([msg])
	if empty(msg)
		let buf = join(readfile(globpath(&runtimepath, 'autoload/vim_clojure_highlight.clj')), "\n")
		let msg = a:platform.Message({"op": "load-file", "file": '(do ' . buf. ')'})
		call fireplace#wait([msg])
	endif
endfunction


" Pass zero explicitly to prevent highlighting local vars
function! vim_clojure_highlight#syntax_match_references(...)
	let platform = fireplace#platform()
	if !s:session_exists(platform)
		echom "Can't load vim-clojure-highlight because no REPL connection was found; is Fireplace running?"
		return
	endif

	call s:require(platform)

	let ns = "'" . fireplace#ns()
	let opts = (a:0 > 0 && !a:1) ? ' :local-vars false' : ''

	let msg = platform.Query("(vim-clojure-highlight/ns-syntax-command " . ns . opts . ")")
	call fireplace#wait([msg])
	execute msg
	let &syntax = &syntax
endfunction

" vim:noet:sw=8:ts=8
