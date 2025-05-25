/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\Tests;

use namespace HTL\{TestChain, TypeVisitor};
use function HTL\Expect\expect;

<<TestChain\Discover>>
function test_visitor_function_test(TestChain\Chain $chain)[]: TestChain\Chain {
  return $chain->group(__FUNCTION__)
    ->test('test_simple_types', () ==> {
      expect(visit<(arraykey, bool, dynamic, float)>())->toEqual(
        '(from tuple: _ ('.
        '(from arraykey: _ arraykey), (from bool: _ bool), '.
        '(from dynamic: _ dynamic), (from float: _ float)'.
        '))',
      );
      expect(visit<(int, mixed, nonnull, noreturn)>())->toEqual(
        '(from tuple: _ ('.
        '(from int: _ int), (from mixed: _ mixed), '.
        '(from nonnull: _ nonnull), (from noreturn: _ noreturn)'.
        '))',
      );
      expect(visit<(nothing, null, num)>())->toEqual(
        '(from tuple: _ ('.
        '(from nothing: _ nothing), (from null: _ null), (from num: _ num)'.
        '))',
      );
      expect(visit<(string, resource, void)>())->toEqual(
        '(from tuple: _ ('.
        '(from string: _ string), (from resource: _ resource), (from void: _ void)'.
        '))',
      );
    })
    ->test('test_class_types', () ==> {
      expect(visit<(MyInterface, MyGenericInterface<int>)>())->toEqual(
        '(from tuple: _ ('.
        '(from interface: _ HTL\TypeVisitor\Tests\MyInterface), '.
        '(from interface: _ HTL\TypeVisitor\Tests\MyGenericInterface<(from int: _ int)>)'.
        '))',
      );

      // Note that `class enum` is an `enum` and not a `class` on hhvm 4.102.
      // I am unable to confirm where in the range 4.102-4.109 the switch was made.
      // I know that 4.109 has a modern `class` intepretation, so `<= 4.108`.
      $enum_class = \version_compare(\HHVM_VERSION, '4.108', '<=')
        ? '(from enum: _ HTL\TypeVisitor\Tests\MyClassEnum)'
        : '(from class: _ HTL\TypeVisitor\Tests\MyClassEnum)';

      expect(visit<(MyEnum, MyClassEnum)>())->toEqual(
        '(from tuple: _ ('.
        '(from enum: _ HTL\TypeVisitor\Tests\MyEnum), '.
        $enum_class.
        '))',
      );

      expect(visit<(MyClass, MyGenericClass<string>)>())->toEqual(
        '(from tuple: _ ('.
        '(from class: _ HTL\TypeVisitor\Tests\MyClass), '.
        '(from class: _ HTL\TypeVisitor\Tests\MyGenericClass<(from string: _ string)>)'.
        '))',
      );

      expect(visit<(MyTrait, MyGenericTrait<num>)>())->toEqual(
        '(from tuple: _ ('.
        '(from trait: _ HTL\TypeVisitor\Tests\MyTrait), '.
        '(from trait: _ HTL\TypeVisitor\Tests\MyGenericTrait<(from num: _ num)>)'.
        '))',
      );
    })
    ->test('test_array_types', () ==> {
      expect(visit<dict<string, int>>())->toEqual(
        '(from dict: _ dict<(from string: _ string), (from int: _ int)>)',
      );

      expect(visit<keyset<int>>())->toEqual(
        '(from keyset: _ keyset<(from int: _ int)>)',
      );

      expect(visit<vec<string>>())->toEqual(
        '(from vec: _ vec<(from string: _ string)>)',
      );

      // Note how both the one and two generic argument variant are supported.
      expect(visit<vec_or_dict<string>>())->toEqual(
        '(from vecOrDict: _ vec_or_dict<(from string: _ string)>)',
      );

      expect(visit<vec_or_dict<int, string>>())->toEqual(
        '(from vecOrDict: _ vec_or_dict<(from int: _ int), (from string: _ string)>)',
      );
    })
    ->test('test_shapes_and_nullables', () ==> {
      expect(visit<
        shape(
          'required' => int,
          'nullable' => ?string,
          ?'optional' => float,
          ?'illusive' => ?bool,
          /*_*/
        ),
      >())->toEqual(
        '(from shape: _ shape('.
        "'required' => (from int: _ int), ".
        "'nullable' => (from nullable: _ ?(from string: _ string)), ".
        "?'optional' => (from float: _ float), ".
        "?'illusive' => (from nullable: _ ?(from bool: _ bool))".
        '))',
      );
    })
    ->test('test_aliasses', () ==> {
      expect(visit<(MyClassAlias, IntAlias)>())->toEqual(
        '(from tuple: _ ('.
        '(from class: HTL\TypeVisitor\Tests\MyClassAlias HTL\TypeVisitor\Tests\MyClass), '.
        '(from int: HTL\TypeVisitor\Tests\IntAlias int)'.
        '))',
      );
    });
}

function visit<reify T>()[]: string {
  return TypeVisitor\visit<T, _, _>(new TestVisitor());
}
