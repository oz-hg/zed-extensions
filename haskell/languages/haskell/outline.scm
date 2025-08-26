([
   (comment)
   (haddock)
 ]? @annotation
 .
 [
  (declaration/bind
    name: (variable) @name)

  (data_type
    "data" @context
    name: (name) @name)

  (type_synomym
    "type" @context
    name: (name) @name)

  (type_synomym
    "type" @context
    name: (name) @name)

  (newtype
    "newtype" @context
    name: (name) @name)

  (class
    "class" @context
    name: (name) @name)

  (instance
    "instance" @context
    name: (name) @name)

  (foreign_import
    "foreign" @context
    (signature
      name: (variable) @name))
 ] @item)

; Hspec

; `describe` or `it` functions within a `Spec` block
; (
;   (decl/signature
;     type: (name) @_type (#match? @_type "^Spec"))
;   .
;   (decl/bind 
;     match: (match
;       (expression 
;         (statement
;           (expression
;             (expression/apply
;                 function: (variable) @name
;                 argument: _ @context
;                 (#match? @name "^[fx]?(describe|it)"))) @item)))))

; ; describe or it functions within a describe block
; ; this allows arbitraryly deep nesting
; (expression/apply
;   function: 
;     (expression/apply
;       function: (variable) @_name
;       (#match? @_name "^[fx]?describe"))
;   argument: 
;     (expression
;       (statement
;         (expression
;           (expression/apply
;                 function: (variable) @name
;                 argument: _ @context
;                 (#match? @name "^[fx]?(describe|it)"))) @item)))

; (expression
;   left_operand: 
;     (expression/apply
;       function: (variable) @_name
;       (#match? @_name "^[fx]?describe"))
;   right_operand: 
;     (expression
;       (statement
;         (expression
;           (expression/apply
;                 function: (variable) @name
;                 argument: _ @context
;                 (#match? @name "^[fx]?(describe|it)"))) @item)))
