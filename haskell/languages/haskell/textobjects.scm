(comment)+ @comment.around

[
  (data_type)
  (type_synomym)
  (newtype)
  (class)
  (instance)
] @class.around

(signature
  (function) @function.inside) @function.around

(function 
  (match 
    expression: (_) @function.inside)) @function.around

(bind 
  (match 
    expression: (_) @function.inside)) @function.around
