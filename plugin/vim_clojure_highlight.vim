" vim-clojure-highlight

augroup vim_clojure_highlight
	autocmd!
	autocmd BufRead,BufNewFile *.clj call vim_clojure_highlight#highlight_references()
augroup END
