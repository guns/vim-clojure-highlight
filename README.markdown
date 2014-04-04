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
local vars, ns-refers, and aliased references every time a `*.clj` file is
(re)loaded.

This will fail silently if fireplace is unable to connect to an nREPL server.

Reload your buffer with `:e` to update syntax matches. Alternately, use the
`:ClojureHighlightReferences` command in a custom autocommand or mapping to do
the same.

See the `doc/vim-clojure-highlight.txt` for more commands and options.
