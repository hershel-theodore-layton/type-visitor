/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\_Private;

function infer_keytype_arraykey(
  dict<arraykey, mixed> $d,
)[]: dict<arraykey, mixed> {
  return $d;
}
