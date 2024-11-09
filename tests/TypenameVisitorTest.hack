/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\Tests;

use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;
use namespace HTL\TypeVisitor;

final class TypenameVisitorTest extends HackTest {
  public function test_nullable_and_inner_alias()[defaults]: void {
    expect(static::visit<int>())->toEqual('int');
    expect(static::visit<?int>())->toEqual('?int');
    expect(static::visit<IntAlias>())->toEqual(
      '\HTL\TypeVisitor\Tests\IntAlias',
    );
    expect(static::visit<?IntAlias>())->toEqual(
      '?\HTL\TypeVisitor\Tests\IntAlias',
    );

    expect(static::visit<AlreadyNullableIntAlias>())->toEqual(
      '\HTL\TypeVisitor\Tests\AlreadyNullableIntAlias',
    );
    // Redundant nullish v
    expect(static::visit<?AlreadyNullableIntAlias>())->toEqual(
      '\HTL\TypeVisitor\Tests\AlreadyNullableIntAlias',
    );
  }

  public function test_shape_suffixes()[defaults]: void {
    expect(static::visit<shape('x' => int, ...)>())->toEqual(
      "shape('x' => int, ...)",
    );
    expect(static::visit<shape('x' => int /*_*/)>())->toEqual(
      "shape('x' => int /*closed*/)",
    );
  }

  private static function visit<reify T>()[]: string {
    return TypeVisitor\visit<T, _, _>(new TypeVisitor\TypenameVisitor(
      null,
      shape('closed_shape_suffix' => ' /*closed*/'),
    ));
  }
}
