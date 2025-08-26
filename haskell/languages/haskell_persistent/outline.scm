; model name
((comment)* @annotation
. (entity_definition name: (type_name) @name) @item)

; model id
((comment)* @annotation
  .
  (surrogate_key . "Id" @name
    type: (type_name) @context
    (attributes) @context) @item)

; fields
((comment)* @annotation
  .
  (field_definition 
    name: (variable) @name
    type: (type_name) @context
    (attributes) @context) @item)
