```
      _                 .-.       _                  .-.   _     .-.  .-.  _     .-.  .-.
     :_;                : :      :_;                 : :  :_;    : :  : : :_;    : : .' `.
.-..-.-,-.,-.,-. .  .--.: :  .--..-.-..-.--. .--.  . : `-..-..--.: `-.: : .-..--.: `-`. .'
: `; : : ,. ,. :`,`'  ..: :_' .; : : :; : ..' '_.:`,`: .. : ' .; : .. : :_: ' .; : .. : :
`.__.:_:_;:_;:_;   `.__.`.__`.__.: `.__.:_; `.__.'   :_;:_:_`._. :_;:_`.__:_`._. :_;:_:_;
                               .-. :                         .-. :           .-. :
                               `._.'                         `._.'           `._.'
```

Extend builtin syntax highlighting to local, referred, and aliased vars in
Clojure buffers.

![demo](https://guns.github.io/vim-clojure-highlight/demo.gif)

Exclusions from clojure.core (via `(:refer-clojure)`) are also reflected.

This is essentially a re-implementation of the dynamic highlighting feature
from Meikel Brandmeyer's VimClojure project.

# Requires:

* [vim-clojure-static](https://github.com/guns/vim-clojure-static)
* [fireplace.vim](https://github.com/tpope/vim-fireplace)

While Vim ships with `vim-clojure-static`, this plugin uses a feature from a
very [recent version][].

If you'd like `vim-clojure-highlight` ported to another REPL plugin, please
create an issue! This can be done quite easily.

[recent version]: https://github.com/guns/vim-clojure-static/commit/82e2156ffbe7dd14990a328cf68f559cbda47376

# Installation

Install as a normal Vim plugin. If you are unfamiliar with this process,
please refer to [Pathogen](https://github.com/tpope/vim-pathogen).

# Usage

`vim-clojure-highlight` installs an autocommand that detects and highlights
local vars, ns-refers, and aliased references every time a `*.clj` file
is (re)loaded. The syntax highlighting reflects the state of the REPL, so
unevaluated references remain unmatched.

This will fail silently if no fireplace nREPL sessions exist.

Reload your buffer with `:e` after an eval to update syntax matches.
Alternately, use the `:ClojureHighlightReferences` command in a custom
autocommand or mapping to do the same.

# Eager loading

If you would like to eager-load a fireplace session so that
vim-clojure-highlight works on the first load of a clojure file, install an
autocommand hook that calls `:Require`:

```vim
" Evaluate Clojure buffers on load
autocmd BufRead *.clj try | silent! Require | catch /^Fireplace/ | endtry
```

# Rainbow parentheses and other syntax extensions

Since vim-clojure-highlight dynamically alters the syntax state of a buffer,
it's possible that other syntax extensions will be affected by this plugin.

A simple workaround is to activate Clojure syntax extensions in an autocmd:

```vim
autocmd Syntax clojure EnableSyntaxExtension
```

For example, this is how you might enable
[`rainbow_parentheses.vim`](https://github.com/kien/rainbow_parentheses.vim)
for Clojure buffers:

```vim
autocmd VimEnter *       RainbowParenthesesToggle
autocmd Syntax   clojure RainbowParenthesesLoadRound
autocmd Syntax   clojure RainbowParenthesesLoadSquare
autocmd Syntax   clojure RainbowParenthesesLoadBraces
```

See `doc/vim-clojure-highlight.txt` for more commands and options.
