/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\Tests;

use namespace HH\Lib\Str;
use namespace HTL\{TestChain, TypeVisitor};
use function HTL\Expect\expect;

<<TestChain\Discover>>
function typename_visitor_test(TestChain\Chain $chain)[]: TestChain\Chain {
  return $chain->group(__FUNCTION__)
    ->test('test_nullable_and_inner_alias', () ==> {
      expect(visit_shapes<int>())->toEqual('int');
      expect(visit_shapes<?int>())->toEqual('?int');
      expect(visit_shapes<IntAlias>())->toEqual(
        '\HTL\TypeVisitor\Tests\IntAlias',
      );
      expect(visit_shapes<?IntAlias>())->toEqual(
        '?\HTL\TypeVisitor\Tests\IntAlias',
      );

      expect(visit_shapes<AlreadyNullableIntAlias>())->toEqual(
        '\HTL\TypeVisitor\Tests\AlreadyNullableIntAlias',
      );
      // Redundant nullish v
      expect(visit_shapes<?AlreadyNullableIntAlias>())->toEqual(
        '\HTL\TypeVisitor\Tests\AlreadyNullableIntAlias',
      );
    })
    ->test('test_shape_suffixes', () ==> {
      expect(visit_shapes<shape('x' => int, ...)>())->toEqual(
        "shape('x' => int, ...)",
      );
      expect(visit_shapes<shape('x' => int /*_*/)>())->toEqual(
        "shape('x' => int, /*closed*/)",
      );
    });
}

function visit_shapes<reify T>()[]: string {
  return TypeVisitor\visit<T, _, _>(new TypeVisitor\TypenameVisitor(
    null,
    shape('closed_shape_suffix' => '/*closed*/'),
  ))
    |> Str\replace($$, "\n", '');
}
