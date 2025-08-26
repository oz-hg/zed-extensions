; Copied from https://github.com/nvim-treesitter/nvim-treesitter/blob/94ea4f436d2b59c80f02e293466c374584f03b8c/queries/haskell_persistent/highlights.scm

; ----------------------------------------------------------------------------
; Literals and comments
(integer) @number

(float) @number @number.float

(char) @string

(string) @string

(attribute_name) @attribute

(attribute_exclamation_mark) @attribute

(con_unit) @string.special.symbol

(comment) @comment

; ----------------------------------------------------------------------------
; Keywords, operators, includes
[
  "Id"
  "Primary"
  "Foreign"
  "deriving"
] @keyword

"=" @operator

; ----------------------------------------------------------------------------
; Functions and variables
(variable) @variable

; ----------------------------------------------------------------------------
; Types
(type) @type

(constructor) @constructor
