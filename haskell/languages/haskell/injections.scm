; Adapted from https://github.com/nvim-treesitter/nvim-treesitter/blob/94ea4f436d2b59c80f02e293466c374584f03b8c/queries/haskell/injections.scm
;
; The reason for adapting is that they do something like this:
;
;   (quasiquote
;    (quoter) @injection.language
;    (quasiquote_body) @injection.content)
;
; But for qualified quoters e.g., `DB.sql` it includes the module name as part of the quoter name
; TODO: submit a pull request upstream?


; -----------------------------------------------------------------------------
; General language injection
(quasiquote
  quoter:
    [
      (quoter (variable) @injection.language)
      (quoter (qualified id: (variable) @injection.language))
    ]
  body: (quasiquote_body) @injection.content)

((comment) @injection.content
  (#set! injection.language "comment"))

((haddock) @injection.content
  (#set! injection.language "comment"))


; -----------------------------------------------------------------------------
; shakespeare library
; NOTE: doesn't support templating
; TODO: add once CoffeeScript parser is added
; ; CoffeeScript: Text.Coffee
; (quasiquote
;  (quoter) @_name
;  (#eq? @_name "coffee")
;  ((quasiquote_body) @injection.content
;   (#set! injection.language "coffeescript")))
; CSS: Text.Cassius, Text.Lucius
(quasiquote
  quoter:
    [
      (quoter (variable) @_name)
      (quoter (qualified id: (variable) @_name))
    ]
  body: (quasiquote_body) @injection.content
  (#any-of? @_name "cassius" "lucius")
  (#set! injection.language "css"))

; HTML: Text.Hamlet
(quasiquote
  quoter:
    [
      (quoter (variable) @_name)
      (quoter (qualified id: (variable) @_name))
    ]
  body: (quasiquote_body) @injection.content
  (#any-of? @_name "hsx" "shamlet" "xshamlet" "hamlet" "xhamlet" "ihamlet")
  (#set! injection.language "html"))

; JS: Text.Julius
(quasiquote
  quoter:
    [
      (quoter (variable) @_name)
      (quoter (qualified id: (variable) @_name))
    ]
  body: (quasiquote_body) @injection.content
  (#any-of? @_name "js" "julius")
  (#set! injection.language "javascript"))

; TS: Text.TypeScript
(quasiquote
  quoter:
    [
      (quoter (variable) @_name)
      (quoter (qualified id: (variable) @_name))
    ]
  body: (quasiquote_body) @injection.content
  (#any-of? @_name "tsc" "tscJSX")
  (#set! injection.language "typescript"))

; -----------------------------------------------------------------------------
; HSX
(quasiquote
  quoter:
    [
      (quoter (variable) @_name)
      (quoter (qualified id: (variable) @_name))
    ]
  body: (quasiquote_body) @injection.content
  (#eq? @_name "hsx")
  (#set! injection.language "html"))

; -----------------------------------------------------------------------------
; Inline JSON from aeson
(quasiquote
  quoter:
    [
      (quoter (variable) @_name)
      (quoter (qualified id: (variable) @_name))
    ]
  body: (quasiquote_body) @injection.content
  (#eq? @_name "aesonQQ")
  (#set! injection.language "json"))

; -----------------------------------------------------------------------------
; SQL
; postgresql-simple
(quasiquote
  quoter:
    [
     (quoter (variable) @_name)
     (quoter (qualified id: (variable) @_name))
    ]
  body: ((quasiquote_body) @injection.content)
  (#any-of? @_name "sql" "sqlQQ")
  (#set! injection.language "sql"))

(quasiquote
  quoter:
    [
     (quoter (variable) @_name)
     (quoter (qualified id: (variable) @_name))
    ]
  body: ((quasiquote_body) @injection.content)
  (#any-of? @_name "persistUpperCase" "persistLowerCase" "persistWith")
  (#set! injection.language "haskell_persistent"))

; -----------------------------------------------------------------------------
; Python
; inline-python
(quasiquote
  (quoter) @injection.language
  (#any-of? @injection.language "pymain" "pye" "py_" "pyf")
  (quasiquote_body) @injection.content)

(quasiquote
  quoter:
    [
     (quoter (variable) @injection.language)
     (quoter (qualified id: (variable) @injection.language))
    ]
  (#any-of? @injection.language "pymain" "pye" "py_" "pyf")
  (quasiquote_body) @injection.content)
