/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\_Private;

function clean(mixed $htl_untyped_variable)[]: CleanTypeStructure {
  $partial__0 = $htl_untyped_variable as shape(
    ?'access_list' => vec<_>,
    ?'alias' => string,
    ?'allows_unknown_fields' => ?bool,
    ?'classname' => string,
    ?'elem_types' => vec<_>,
    ?'exact' => bool,
    ?'fields' => dict<_, _>,
    ?'generic_types' => vec<_>,
    ?'is_cls_cns' => bool,
    'kind' => int,
    ?'like' => bool,
    ?'name' => string,
    ?'nullable' => ?bool,
    ?'opaque' => bool,
    ?'optional_shape_field' => ?bool,
    ?'param_types' => vec<_>,
    ?'return_type' => dict<_, _>,
    ?'root_name' => ?string,
    ?'typevars' => string,
    ?'value' => vec<_>,
    ...
  );

  // Type structures are sometimes lacking the opaque field for newtypes.
  // We can patch around this by using runtime reflection.
  if (
    Shapes::keyExists($partial__0, 'alias') &&
    !Shapes::idx($partial__0, 'opaque', false) &&
    idx(
      (new \ReflectionTypeAlias($partial__0['alias']))->getTypeStructure(),
      'opaque',
      false,
    ) === true
  ) {
    $partial__0['opaque'] = true;
  }

  return $partial__0;
}
