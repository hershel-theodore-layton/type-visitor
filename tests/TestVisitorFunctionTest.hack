/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\Tests;

use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;
use namespace HTL\TypeVisitor;

final class TestVisitorFunctionTest extends HackTest {
  public function test_simple_types(): void {
    expect(static::visit<(arraykey, bool, dynamic, float)>())->toEqual(
      '(from tuple: _ ('.
      '(from arraykey: _ arraykey), (from bool: _ bool), '.
      '(from dynamic: _ dynamic), (from float: _ float)'.
      '))',
    );
    expect(static::visit<(int, mixed, nonnull, noreturn)>())->toEqual(
      '(from tuple: _ ('.
      '(from int: _ int), (from mixed: _ mixed), '.
      '(from nonnull: _ nonnull), (from noreturn: _ noreturn)'.
      '))',
    );
    expect(static::visit<(nothing, null, num)>())->toEqual(
      '(from tuple: _ ('.
      '(from nothing: _ nothing), (from null: _ null), (from num: _ num)'.
      '))',
    );
    expect(static::visit<(string, resource, void)>())->toEqual(
      '(from tuple: _ ('.
      '(from string: _ string), (from resource: _ resource), (from void: _ void)'.
      '))',
    );
  }

  public function test_class_types(): void {
    expect(static::visit<(MyInterface, MyGenericInterface<int>)>())->toEqual(
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

    expect(static::visit<(MyEnum, MyClassEnum)>())->toEqual(
      '(from tuple: _ ('.
      '(from enum: _ HTL\TypeVisitor\Tests\MyEnum), '.
      $enum_class.
      '))',
    );

    expect(static::visit<(MyClass, MyGenericClass<string>)>())->toEqual(
      '(from tuple: _ ('.
      '(from class: _ HTL\TypeVisitor\Tests\MyClass), '.
      '(from class: _ HTL\TypeVisitor\Tests\MyGenericClass<(from string: _ string)>)'.
      '))',
    );

    expect(static::visit<(MyTrait, MyGenericTrait<num>)>())->toEqual(
      '(from tuple: _ ('.
      '(from trait: _ HTL\TypeVisitor\Tests\MyTrait), '.
      '(from trait: _ HTL\TypeVisitor\Tests\MyGenericTrait<(from num: _ num)>)'.
      '))',
    );
  }

  public function test_array_types(): void {
    expect(static::visit<dict<string, int>>())->toEqual(
      '(from dict: _ dict<(from string: _ string), (from int: _ int)>)',
    );

    expect(static::visit<keyset<int>>())->toEqual(
      '(from keyset: _ keyset<(from int: _ int)>)',
    );

    expect(static::visit<vec<string>>())->toEqual(
      '(from vec: _ vec<(from string: _ string)>)',
    );

    // Note how both the one and two generic argument variant are supported.
    expect(static::visit<vec_or_dict<string>>())->toEqual(
      '(from vecOrDict: _ vec_or_dict<(from string: _ string)>)',
    );

    expect(static::visit<vec_or_dict<int, string>>())->toEqual(
      '(from vecOrDict: _ vec_or_dict<(from int: _ int), (from string: _ string)>)',
    );
  }

  public function test_shapes_and_nullables(): void {
    expect(static::visit<
      shape(
        'required' => int,
        'nullable' => ?string,
        ?'optional' => float,
        ?'illusive' => ?bool,
        MyClass::ONE => num,
      ),
    >())->toEqual(
      '(from shape: _ shape('.
      "'required' => (from int: _ int), ".
      "'nullable' => (from nullable: _ ?(from string: _ string)), ".
      "?'optional' => (from float: _ float), ".
      "?'illusive' => (from nullable: _ ?(from bool: _ bool)), ".
      '1 => (from num: _ num)'.
      '))',
    );
  }

  public function test_aliasses(): void {
    expect(static::visit<(MyClassAlias, IntAlias)>())->toEqual(
      '(from tuple: _ ('.
      '(from class: HTL\TypeVisitor\Tests\MyClassAlias HTL\TypeVisitor\Tests\MyClass), '.
      '(from int: HTL\TypeVisitor\Tests\IntAlias int)'.
      '))',
    );
  }

  private static function visit<reify T>()[]: string {
    return TypeVisitor\visit<T, _, _>(new TestVisitor());
  }
}
