" vim-clojure-highlight

if !exists('g:clojure_highlight_references')
	let g:clojure_highlight_references = 1
endif

if !exists('g:clojure_highlight_local_vars')
	let g:clojure_highlight_local_vars = 1
endif

function! s:syntax_match_references()
	if g:clojure_highlight_references
		call vim_clojure_highlight#syntax_match_references(g:clojure_highlight_local_vars)
	endif
endfunction

function! s:toggle_clojure_highlight_references()
	let g:clojure_highlight_references = !g:clojure_highlight_references

	if g:clojure_highlight_references
		call s:syntax_match_references()
	else
		unlet! b:clojure_syntax_keywords b:clojure_syntax_without_core_keywords
		let &syntax = &syntax
	endif
endfunction

augroup vim_clojure_highlight
	autocmd!
	autocmd BufRead *.clj ClojureHighlightReferences
augroup END

command! -bar ToggleClojureHighlightReferences call s:toggle_clojure_highlight_references()
command! -bar ClojureHighlightReferences call s:syntax_match_references()

" vim:noet:sw=8:ts=8
