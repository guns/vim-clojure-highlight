" vim-clojure-highlight

if !exists('g:clojure_highlight_references')
	let g:clojure_highlight_references = 1
endif

augroup vim_clojure_highlight
	autocmd!
	autocmd BufRead *.clj if g:clojure_highlight_references | call vim_clojure_highlight#syntax_match_references() | endif
augroup END

command! ToggleClojureHighlightReferences let g:clojure_highlight_references = !g:clojure_highlight_references | edit
