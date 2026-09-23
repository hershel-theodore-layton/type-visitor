/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor;

type TAlias = shape(
  'alias' => ?string,
  'counter' => int,
  'opaque' => bool,
  // Instantiated HHVM type structures, keyed by alias parameter name.
  ?'typevar_types' => KeyedContainer<string, mixed>,
  /*_*/
);
