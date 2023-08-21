/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\_Private;

function map_with_key_and_counter<Tk as arraykey, Tv, Tout>(
  KeyedContainer<Tk, Tv> $traversable,
  inout int $counter,
  (function(inout int, Tk, Tv)[_]: Tout) $func,
)[ctx $func]: vec<Tout> {
  $out = vec[];

  foreach ($traversable as $k => $v) {
    $out[] = $func(inout $counter, $k, $v);
  }

  return $out;
}
