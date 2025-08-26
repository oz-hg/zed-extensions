; Adapted from neovim queries with heavy modifications
; @see https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/refs/heads/master/queries/haskell/highlights.scm

; ----------------------------------------------------------------------------
; Variables

; import and export lists
(export (variable) @variable)
(import_name (variable) @variable)

; import Foo (Bar(field))
(import_name
  (name)
  .
  (children (variable) @variable))

; variable definitions
; all pattern matches or variable bindings introduce new variables
(pattern (as (variable) @variable.definition))
(pattern/variable) @variable.definition
(decl/bind name: (variable) @variable.definition)
(decl/function name: (variable) @variable.definition)

; every variable used within expressions
; this does not include pattern matches or function params
(expression/variable) @variable
(expression/qualified (variable) @variable)

; Look for variables that look like functions and overwrite the capture group
; ----------------------------------------------------------------------------
; Functions

(apply
  function:
    [
      (expression/variable) @function.call
      (expression/qualified (variable) @function.call)
    ])

; functions with inline signatures
; e.g., foo (f :: a -> b) = _
(signature
  pattern: (pattern/variable) @function
  type: (function))

; variable on the lhs of operators that expect a function
(infix
  left_operand:
    [
      (expression/variable) @function.call
      (expression/qualified (variable) @function.call)
    ]
  operator: (operator) @_name
  (#any-of? @_name "$" "<$>" "<$$>" "=<<"))

; variable on the rhs of operators that expect a function
(infix
  operator: (operator) @_name
  right_operand:
    [
      (expression/variable) @function.call
      (expression/qualified (variable) @function.call)
    ]
  (#any-of? @_name "&" "<&>" "<&&>" ">>="))

; chaining operators like `&`
(infix
  operator: (operator) @_name
  right_operand: (infix
    left_operand:
      [
        (expression/variable) @function.call
        (expression/qualified (variable) @function.call)
      ]
    operator: (operator))
  (#any-of? @_name "&" "<&>" "<&&>" ">>="))

; treat the rhs of a bind as a function so we have a bit more color
(bind
  pattern: (variable)
  expression:
    [
      (expression/variable) @function.call
      (expression/qualified (variable) @function.call)
    ])

; lhs: function composition, arrows, monadic composition
(infix
  [
    (variable) @function
    (qualified (variable) @function)
  ]
  .  (operator) @_op
  (#any-of? @_op "." ">>>" "<<<" "***" ">=>" "<=<"))

; rhs: function composition, arrows, monadic composition
(infix
  (operator) @_op
  .
  [
    (variable) @function
    (qualified (variable) @function)
  ]
  (#any-of? @_op "." ">>>" "<<<" "***" ">=>" "<=<"))

; view patterns
(view_pattern
  [
    (expression/variable) @function.call
    (expression/qualified
      (variable) @function.call)
  ])

; ----------------------------------------------------------------------------
; Literals and constants

(integer) @number
(negation) @number
(float) @number.float

(char) @string.special
(string) @string

(constructor) @constructor
((constructor) @boolean
  (#any-of? @boolean "True" "False"))

; otherwise == True
((variable) @boolean
  (#eq? @boolean "otherwise"))

((variable) @_name @variable.error
  (#eq? @_name "undefined"))

; ----------------------------------------------------------------------------
; Types

; every signature is a declaration
; TODO: what should the capture group be?
(signature name: (variable) @variable.declaration)

(name) @type

; (type/star) @type.special

; TODO: not sure how to match kinds in every position
; (annotated kind: (variable) @type.special)

; a, b, c :: _
(binding_list (variable) @variable.type)

; (type/variable) @variable.type
; (type_param/variable) @variable.type
; (quantified_variables (variable) @variable.type)

; record fields
(field_name (variable) @property)

; record field projections e.g., `(.field)`
(projection_selector
  field: (variable) @property)

(label) @property

; ----------------------------------------------------------------------------
; Syntax

(cpp) @preproc
(pragma) @preproc
(comment) @comment
(haddock) @comment.doc

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

[
  ","
  ";"
  "|"
] @punctuation.delimiter

[
  "forall"
  ; "∀" ; utf-8 is not cross-platform safe
] @keyword.repeat

[
  "if"
  "then"
  "else"
  "case"
  "of"
] @keyword.conditional

[
  "as"
  "import"
  "qualified"
  "module"
] @keyword.import

[
  "where"
  "let"
  "in"
  "class"
  "instance"
  "default"
  "foreign"
  "pattern"
  "data"
  "newtype"
  "family"
  "type"
  "as"
  "hiding"
  "deriving"
  "via"
  "stock"
  "anyclass"
  "do"
  "mdo"
  "rec"
  "infix"
  "infixl"
  "infixr"
] @keyword

[
  (operator)
  (constructor_operator)
  (all_names)
  (calling_convention)
  "."
  ".."
  "="
  "::"
  "=>"
  "->"
  "<-"
  "\\"
  "`"
  "'"
  "@"
  "!"
  "~"
  "$"
  "$$"
] @operator

; treat infix functions as operators
(infix_id
  [
    (variable) @operator
    (qualified (variable) @operator)
  ])

; holes and record wildcards
(wildcard) @variable.special

; module names
(module (module_id) @title)

; Highlighting of quasiquote_body for other languages is handled by injections.scm
; ----------------------------------------------------------------------------
; Quasi-quotes

; the parser doesn't handle delimiters correctly
; so where having to match them here in order to get syntax highlighting

(quasiquote
  quoter: [
    (quoter (variable) @_name)
    (quoter (qualified id: (variable) @_name))
  ]
  (#eq? @_name "qq")
  body: (quasiquote_body) @string)

(quasiquote
  "[" @punctuation.delimiter
  [
    (quoter (variable) @function.call)
    (quoter (qualified id: (variable) @function.call))
  ]
  "|" @punctuation.delimiter
  (quasiquote_body)
  "|]" @punctuation.delimiter)

(quote
  "[" @punctuation.delimiter
  quoter: "d" @function.call
  "|" @punctuation.delimiter
  (quoted_decls)
  "|]" @punctuation.delimiter)

(quote
  "[" @punctuation.delimiter
  quoter: "e" @function.call
  "|" @punctuation.delimiter
  (quoted_expression)
  "|]" @punctuation.delimiter)

(quote
  "[" @punctuation.delimiter
  quoter: "p" @function.call
  "|" @punctuation.delimiter
  (quoted_pattern)
  "|]" @punctuation.delimiter)

(quote
  "[" @punctuation.delimiter
  quoter: "t" @function.call
  "|" @punctuation.delimiter
  (quoted_type)
  "|]" @punctuation.delimiter)

; ----------------------------------------------------------------------------
; Exceptions/error handling

; ((variable) @keyword.exception
;   (#any-of? @keyword.exception
;     "error" "undefined" "try" "tryJust" "tryAny" "catch" "catches" "catchJust" "handle" "handleJust"
;     "throw" "throwIO" "throwTo" "throwError" "ioError" "mask" "mask_" "uninterruptibleMask"
;     "uninterruptibleMask_" "bracket" "bracket_" "bracketOnErrorSource" "finally" "fail"
;     "onException" "expectationFailure"))

; ; ----------------------------------------------------------------------------
; ; Debugging

; ((variable) @keyword.debug
;   (#any-of? @keyword.debug
;     "trace" "traceId" "traceShow" "traceShowId" "traceWith" "traceShowWith" "traceStack" "traceIO"
;     "traceM" "traceShowM" "traceEvent" "traceEventWith" "traceEventIO" "flushEventLog" "traceMarker"
;     "traceMarkerIO"))