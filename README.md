# Custom Haskell Extensions for Zed

A set of customized language extensions for the [Zed](https://zed.dev) editor.
Adapted from the standard haskell [extension](https://github.com/zed-extensions/haskell).

I built this for my own use but I'll consider upstreaming these changes if others find them useful.

I'm very particular about my editor experience and found the existing haskell extension lacking:

- The standard Haskell extension uses an outdated tree-sitter grammar
- No syntax highlighting for Haskell Persistent files
- No comment highlighting for TODOs and issue references

### Updated Haskell Grammar

- Uses a newer [tree-sitter-haskell](https://github.com/tree-sitter/tree-sitter-haskell) grammar
- Custom tree-sitter queries for highlighting, outline, injections, and text objects adapted from [neovim queries](https://github.com/nvim-treesitter/nvim-treesitter/)

### Haskell Persistent Support

- Added language support for Persistent models using the excellent [tree-sitter-haskell-persistent](https://github.com/MercuryTechnologies/tree-sitter-haskell-persistent) grammar.
- Includes syntax highlighting for Persistent models in quasi-quoters like `persistUpperCase`, `persistLowerCase`, and `persistWith`

### Comment Language Support

Added a language for comments using [tree-sitter-comment](https://github.com/stsewd/tree-sitter-comment):

- Highlights TODO keywords (TODO, FIXME, NOTE, etc.)
- Highlights issue numbers like `PROJECT-666` or `#123`
- Haskell, Haskell Persistent, and Cabal languages have injections to parse comments with this grammar

## Installation

Clone the repo and install the extensions as dev extensions.  Refer to the [zed extension docs](https://zed.dev/docs/extensions/developing-extensions#developing-an-extension-locally) for how to do that.
