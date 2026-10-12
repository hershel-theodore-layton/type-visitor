/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\Tests;

use namespace HH\Lib\Str;
use namespace HTL\{TestChain, TypeVisitor};
use type UnexpectedValueException;
use function HTL\Expect\{expect, expect_invoked};

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
    ->test('test_generic_aliases', () ==> {
      $prefix = '\\HTL\TypeVisitor\Tests\\';
      expect(visit_shapes<GenericAlias<int>>())
        ->toEqual($prefix.'GenericAlias<int>');
      expect(visit_shapes<GenericNewtype<string>>())
        ->toEqual($prefix.'GenericNewtype<string>');
      expect(visit_shapes<Reordered<int, string>>())
        ->toEqual($prefix.'Reordered<int, string>');
      expect(visit_shapes<Unused<string>>())
        ->toEqual($prefix.'Unused<string>');
      expect(visit_shapes<Nested<string>>())
        ->toEqual($prefix.'Nested<string>');
      expect(visit_shapes<GenericAlias<GenericNewtype<int>>>())
        ->toEqual($prefix.'GenericAlias<'.$prefix.'GenericNewtype<int>>');
      expect(visit_shapes<?GenericAlias<int>>())
        ->toEqual('?'.$prefix.'GenericAlias<int>');
      expect(visit_shapes<NullableAlias<int>>())
        ->toEqual($prefix.'NullableAlias<int>');
      expect(visit_shapes<GenericAlias<shape('x' => int /*_*/)>>())
        ->toEqual($prefix."GenericAlias<shape('x' => int, /*closed*/)>");
    })
    ->test('test_erased_builtin_alias_arguments', () ==> {
      // Captured reified metadata: checked Hack rejects these built-ins as
      // direct reified arguments, so exercise their erased structures here.
      $classname = dict[
        'kind' => 4,
        'opaque' => true,
        'alias' => 'HH\\classname',
      ];
      $typename = dict[
        'kind' => 4,
        'opaque' => true,
        'alias' => 'HH\\typename',
      ];
      $unused = dict['kind' => 1, 'alias' => 'HTL\\TypeVisitor\\Tests\\Unused'];
      $unused['typevar_types'] = dict['T' => $typename];
      foreach (vec[
        $classname,
        $typename,
        dict['kind' => 20, 'generic_types' => vec[$classname]],
        dict[
          'kind' => 19,
          'generic_types' => vec[dict['kind' => 4], $typename],
        ],
        $unused,
      ] as $structure) {
        expect_invoked(() ==> {
          $counter = 0;
          return TypeVisitor\_Private\visit(
            new TypeVisitor\TypenameVisitor(),
            TypeVisitor\_Private\clean($structure),
            inout $counter,
          );
        })->toHaveThrown<UnexpectedValueException>('HHVM did not retain');
      }
    })
    ->test('test_unnamed_integer_shape_keys', () ==> {
      expect_invoked(visit_shapes<shape(MyClass::ONE => int /*_*/)>)
        ->toHaveThrown<UnexpectedValueException>('shape key namer');
      expect_invoked(visit_shapes<shape(MyClass::NEGATIVE_ONE => int /*_*/)>)
        ->toHaveThrown<UnexpectedValueException>('shape key namer');
      expect_invoked(visit_shapes<IntegerKeyShape>)
        ->toHaveThrown<UnexpectedValueException>('shape key namer');
      expect_invoked(
        () ==> TypeVisitor\visit<shape(MyClass::ONE => int /*_*/), _, _>(
          new TypeVisitor\TypenameVisitor(($_, $_)[] ==> null),
        ),
      )
        ->toHaveThrown<UnexpectedValueException>('shape key namer');
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
