/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor;

use namespace HH\Lib\{C, Str};

/**
 * Returns a textual `typename<T>` suitable for embedding in any namespace.
 * (All types that are not auto-imported are fully qualified.)
 */
final class TypenameVisitor implements TypeDeclVisitor<string, string> {
  const type TShapeKeyNamer = (function(?string, arraykey)[]: ?string);
  public function __construct(
    private this::TShapeKeyNamer $shapeKeyNamer = ($_, $_)[] ==> null,
  )[] {}

  public function panic(string $message)[]: string {
    throw new \UnexpectedValueException($message);
  }

  public function unsupportedType(string $type_name)[]: string {
    throw new \UnexpectedValueException($type_name);
  }

  public function shapeField(
    ?string $parent_shape_name,
    arraykey $key,
    bool $_is_class_constant,
    bool $is_optional,
    string $type,
  )[]: string {
    return Str\format(
      '%s%s => %s',
      $is_optional ? '?' : '',
      (($this->shapeKeyNamer)($parent_shape_name, $key)) ??
        ($key is string ? _Private\string_export($key) : (string)$key),
      $type,
    );
  }

  public function arraykey(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'arraykey');
  }

  public function bool(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'bool');
  }

  public function class(
    TAlias $alias,
    string $classname,
    vec<string> $generics,
  )[]: string {
    $classname = '\\'.$classname;
    return static::aliasOr(
      $alias,
      C\is_empty($generics)
        ? $classname
        : Str\format('%s<%s>', $classname, Str\join($generics, ', ')),
    );
  }

  public function dict(TAlias $alias, string $key, string $value)[]: string {
    return static::aliasOr($alias, Str\format('dict<%s, %s>', $key, $value));
  }

  public function dynamic(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'dynamic');
  }

  public function enum(TAlias $alias, string $classname)[]: string {
    return static::aliasOr($alias, $this->class($alias, $classname, vec[]));
  }

  public function float(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'float');
  }

  public function int(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'int');
  }

  public function interface(
    TAlias $alias,
    string $classname,
    vec<string> $generics,
  )[]: string {
    return static::aliasOr($alias, $this->class($alias, $classname, $generics));
  }

  public function keyset(TAlias $alias, string $inner)[]: string {
    return static::aliasOr($alias, Str\format('keyset<%s>', $inner));
  }

  public function mixed(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'mixed');
  }

  public function nonnull(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'nonnull');
  }

  public function noreturn(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'noreturn');
  }

  public function nothing(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'nothing');
  }

  public function null(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'null');
  }

  public function nullable(TAlias $alias, string $inner)[]: string {
    return static::aliasOr($alias, '?'.$inner);
  }

  public function num(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'num');
  }

  public function resource(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'resource');
  }

  public function shape(
    TAlias $alias,
    vec<string> $fields,
    bool $is_open,
  )[]: string {
    return static::aliasOr(
      $alias,
      Str\join($fields, ', ')
        |> $is_open ? (C\is_empty($fields) ? $$.'...' : $$.', ...') : $$
        |> Str\format('shape(%s)', $$),
    );
  }

  public function string(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'string');
  }

  public function trait(
    TAlias $alias,
    string $classname,
    vec<string> $generics,
  )[]: string {
    return static::aliasOr($alias, $this->class($alias, $classname, $generics));
  }

  public function tuple(TAlias $alias, vec<string> $elements)[]: string {
    return static::aliasOr(
      $alias,
      Str\format('(%s)', Str\join($elements, ', ')),
    );
  }

  public function vec(TAlias $alias, string $inner)[]: string {
    return static::aliasOr($alias, Str\format('vec<%s>', $inner));
  }

  public function vecOrDict(TAlias $alias, vec<string> $inner)[]: string {
    return static::aliasOr(
      $alias,
      Str\format('vec_or_dict<%s>', Str\join($inner, ', ')),
    );
  }

  public function void(TAlias $alias)[]: string {
    return static::aliasOr($alias, 'void');
  }

  private static function aliasOr(
    TAlias $alias,
    string $alternative,
  )[]: string {
    return $alias['alias'] |> $$ is nonnull ? '\\'.$$ : $alternative;
  }
}
