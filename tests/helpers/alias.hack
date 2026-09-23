/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\Tests;

type MyClassAlias = MyClass;
newtype IntAlias = int;
newtype AlreadyNullableIntAlias = ?int;

type GenericAlias<T> = vec<T>;
newtype GenericNewtype<T> = vec<T>;
newtype Reordered<Ta, Tb as arraykey> = dict<Tb, Ta>;
type Unused<T> = int;
type Nested<T> = GenericNewtype<vec<T>>;
type NullableAlias<T> = ?vec<T>;
