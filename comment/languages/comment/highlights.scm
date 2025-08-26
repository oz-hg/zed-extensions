(uri) @link_uri

; issue number (#123)
( "text" @number
  (#match? @number "^#[0-9]+$"))

; issue number like PROJECT-666
; HACK: I broke this up because I couldn't match a literal dash otherwise
( ("text" @_project (#match? @_project "^[A-Z]+$")) @number
. ("text" @_dash (#eq? @_dash "-")) @number
. ("text" @_number (#match? @_number "^[0-9]+$")) @number)

; this is how the grammar would like to be used
; when there's a trailing colon the tree will contain the nodes
((tag
  [
    ((name) @comment.todo
      (#any-of? @comment.todo "TODO" "WIP"))

    ((name) @comment.note
      (#any-of? @comment.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST" "NB"))

    ((name) @comment.warning
      (#any-of? @comment.warning "HACK" "WARNING" "WARN" "FIX" "KLUDGE"))

    ((name) @comment.error
      (#any-of? @comment.error "FIXME" "BUG" "ERROR"))
  ]
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?))

; I want the colon to be optional so we're having to match symbols the hard way
([
  ("text" @comment.todo
    (#any-of? @comment.todo "TODO" "WIP"))

  ("text" @comment.note
    (#any-of? @comment.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST" "NB"))

  ( "text" @comment.warning
    (#any-of? @comment.warning "HACK" "WARNING" "WARN" "FIX" "KLUDGE"))

  ( "text" @comment.error
    (#any-of? @comment.error "FIXME" "BUG" "ERROR"))
 ]

 ( "text" @_open @punctuation.bracket
   "text" @constant
   "text" @_close @punctuation.bracket
   (#eq? @_open "(")
   (#eq? @_close ")")))

; this will match just the bare keyword
[
  ("text" @comment.todo
    (#any-of? @comment.todo "TODO" "WIP"))

  ("text" @comment.note
    (#any-of? @comment.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST" "NB"))

  ( "text" @comment.warning
    (#any-of? @comment.warning "HACK" "WARNING" "WARN" "FIX" "KLUDGE"))

  ( "text" @comment.error
    (#any-of? @comment.error "FIXME" "BUG" "ERROR"))
]
