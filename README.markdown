

           _
          (_)
    __   ___ _ __ ___
    \ \ / / | '_ ` _ \
     \ V /| | | | | | |
      \_/ |_|_| |_| |_|


          _       _
         | |     (_)
      ___| | ___  _ _   _ _ __ ___
     / __| |/ _ \| | | | | '__/ _ \
    | (__| | (_) | | |_| | | |  __/
     \___|_|\___/| |\__,_|_|  \___|
                _/ |
               |__/
     _     _       _     _ _       _     _
    | |   (_)     | |   | (_)     | |   | |
    | |__  _  __ _| |__ | |_  __ _| |__ | |_
    | '_ \| |/ _` | '_ \| | |/ _` | '_ \| __|
    | | | | | (_| | | | | | | (_| | | | | |_
    |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|
              __/ |           __/ |
             |___/           |___/



Extend builtin syntax highlighting to referred and aliased vars in Clojure
buffers.

This is essentially a re-implementation of the dynamic highlighting feature
from Meikel Brandmeyer's VimClojure project.

# Requires:

* [fireplace.vim](https://github.com/tpope/vim-fireplace)

If you'd like this ported to another REPL plugin, please create an issue! This
can be done quite easily.

# Installation

Install as a normal Vim plugin. If you are unfamiliar with this process,
please refer to [Pathogen](https://github.com/tpope/vim-pathogen).

# Usage

`vim-clojure-highlight` installs a hook that executes the relevant `syntax`
statements when a `*.clj` file is loaded.

This will fail silently if fireplace is unable to connect to an nREPL server.

Reload your buffer with `:e` to update syntax matches.

Reference highlighting can be toggled with the following command:

```vim
:ToggleClojureHighlightReferences
```

and can be disabled by default:

```vim
let g:clojure_highlight_references = 0
```
