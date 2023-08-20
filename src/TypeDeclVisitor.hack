/** static-type-assertion-code-generator-interfaces is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen;

interface TypeDeclVisitor<Tt, Tf> {
  /**
   * Invoked when a bad type declaration is encountered,
   * f.e. a `vec<T>` without an inner type (`T`),
   */
  public function panic(string $message)[]: Tt;

  /**
   * Invoked when a type is encountered that is impossible to handle.
   */
  public function unsupportedType(string $type_name)[]: Tt;

  /**
   * @param $parent_shape_name the `TAlias['alias']` of the embedding shape.
   */
  public function shapeField(
    ?string $parent_shape_name,
    arraykey $key,
    bool $is_class_constant,
    bool $is_optional,
    Tt $type,
  )[]: Tf;

  public function arraykey(TAlias $alias)[]: Tt;
  public function bool(TAlias $alias)[]: Tt;
  public function class(TAlias $alias, string $class, vec<Tt> $types)[]: Tt;
  public function dict(TAlias $alias, Tt $key, Tt $value)[]: Tt;
  public function dynamic(TAlias $alias)[]: Tt;
  public function enum(TAlias $alias, string $classname)[]: Tt;
  public function float(TAlias $alias)[]: Tt;
  public function int(TAlias $alias)[]: Tt;
  public function interface(TAlias $alias, string $class, vec<Tt> $types)[]: Tt;
  public function keyset(TAlias $alias, Tt $inner)[]: Tt;
  public function mixed(TAlias $alias)[]: Tt;
  public function nonnull(TAlias $alias)[]: Tt;
  public function nothing(TAlias $alias)[]: Tt;
  public function null(TAlias $alias)[]: Tt;
  public function nullable(TAlias $alias, Tt $inner)[]: Tt;
  public function num(TAlias $alias)[]: Tt;
  public function shape(TAlias $alias, vec<Tf> $fields, bool $is_open)[]: Tt;
  public function string(TAlias $alias)[]: Tt;
  public function resource(TAlias $alias)[]: Tt;
  public function trait(TAlias $alias, string $class, vec<Tt> $types)[]: Tt;
  public function tuple(TAlias $alias, vec<Tt> $elements)[]: Tt;
  public function vec(TAlias $alias, Tt $inner)[]: Tt;
  public function vecOrDict(TAlias $alias, vec<Tt> $inner)[]: Tt;
}
