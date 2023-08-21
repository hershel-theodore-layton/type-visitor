/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\_Private;

// Built-in as https://github.com/facebook/hhvm/blob/master/hphp/hack/hhi/typestructure.hhi
// This can not be used portably, because of hadva.
// Removed classname-ness to classname, since this can not be asserted.
type CleanTypeStructure = shape(
  ?'access_list' => KeyedContainer<int, mixed>,
  ?'alias' => string,
  ?'allows_unknown_fields' => ?bool,
  ?'classname' => string,
  ?'elem_types' => KeyedContainer<int, mixed>,
  ?'exact' => bool,
  ?'fields' => KeyedContainer<arraykey, mixed>,
  ?'generic_types' => KeyedContainer<int, mixed>,
  ?'is_cls_cns' => bool,
  'kind' => int,
  ?'like' => bool,
  ?'name' => string,
  ?'nullable' => ?bool,
  ?'opaque' => bool,
  ?'optional_shape_field' => ?bool,
  ?'param_types' => KeyedContainer<int, mixed>,
  ?'return_type' => KeyedContainer<arraykey, mixed>,
  ?'root_name' => ?string,
  ?'typevars' => string,
  ?'value' => KeyedContainer<arraykey, mixed>,
  ...
);
