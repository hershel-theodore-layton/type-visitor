/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\Tests;

interface MyInterface {}
interface MyGenericInterface<T> {}
enum MyEnum: int {}
enum class MyClassEnum: int {}
final class MyClass {
  const int ONE = 1;
}
final class MyGenericClass<T> {}
trait MyTrait {}
trait MyGenericTrait<T> {}
