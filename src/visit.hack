/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor;

function visit<reify T, Tt, Tf>(TypeDeclVisitor<Tt, Tf> $visitor)[]: Tt {
  $counter = 0;
  return \HH\ReifiedGenerics\get_type_structure<T>()
    |> _Private\clean($$)
    |> _Private\visit($visitor, $$, inout $counter);
}
