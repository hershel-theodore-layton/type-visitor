/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\Tests;

use namespace HH\Lib\{C, Str};
use namespace HTL\TypeVisitor\_Private;
use type HTL\TypeVisitor\{TAlias, TypeDeclVisitor};

final class TestVisitor implements TypeDeclVisitor<string, string> {
  const TAlias EMPTY_ALIAS =
    shape('alias' => null, 'counter' => 0, 'opaque' => false);

  public function panic(string $message)[]: string {
    return static::fmt(__FUNCTION__, static::EMPTY_ALIAS, $message);
  }

  public function unsupportedType(string $type_name)[]: string {
    return static::fmt(__FUNCTION__, static::EMPTY_ALIAS, $type_name);
  }

  public function shapeField(
    ?string $_parent_shape_name,
    arraykey $key,
    bool $_is_class_constant,
    bool $is_optional,
    string $type,
  )[]: string {
    return Str\format(
      '%s%s => %s',
      $is_optional ? '?' : '',
      $key is string ? _Private\string_export($key) : (string)$key,
      $type,
    );
  }

  public function arraykey(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function bool(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function class(
    TAlias $alias,
    string $classname,
    vec<string> $generics,
  )[]: string {
    return static::fmt(
      __FUNCTION__,
      $alias,
      C\is_empty($generics)
        ? $classname
        : Str\format('%s<%s>', $classname, Str\join($generics, ', ')),
    );
  }

  public function dict(TAlias $alias, string $key, string $value)[]: string {
    return static::fmt(
      __FUNCTION__,
      $alias,
      Str\format('dict<%s, %s>', $key, $value),
    );
  }

  public function dynamic(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function enum(TAlias $alias, string $classname)[]: string {
    return static::fmt(__FUNCTION__, $alias, $classname);
  }

  public function float(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function int(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function interface(
    TAlias $alias,
    string $classname,
    vec<string> $generics,
  )[]: string {
    return static::fmt(
      __FUNCTION__,
      $alias,
      C\is_empty($generics)
        ? $classname
        : Str\format('%s<%s>', $classname, Str\join($generics, ', ')),
    );
  }

  public function keyset(TAlias $alias, string $inner)[]: string {
    return static::fmt(__FUNCTION__, $alias, Str\format('keyset<%s>', $inner));
  }

  public function mixed(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function nonnull(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function noreturn(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function nothing(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function null(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function nullable(TAlias $alias, string $inner)[]: string {
    return static::fmt(__FUNCTION__, $alias, '?'.$inner);
  }

  public function num(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function resource(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function shape(
    TAlias $alias,
    vec<string> $fields,
    bool $is_open,
  )[]: string {
    return static::fmt(
      __FUNCTION__,
      $alias,
      Str\join($fields, ', ')
        |> $is_open ? (C\is_empty($fields) ? $$.'...' : $$.', ...') : $$
        |> Str\format('shape(%s)', $$),
    );
  }

  public function string(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  public function trait(
    TAlias $alias,
    string $classname,
    vec<string> $generics,
  )[]: string {
    return static::fmt(
      __FUNCTION__,
      $alias,
      C\is_empty($generics)
        ? $classname
        : Str\format('%s<%s>', $classname, Str\join($generics, ', ')),
    );
  }

  public function tuple(TAlias $alias, vec<string> $elements)[]: string {
    return static::fmt(
      __FUNCTION__,
      $alias,
      Str\format('(%s)', Str\join($elements, ', ')),
    );
  }

  public function vec(TAlias $alias, string $inner)[]: string {
    return static::fmt(__FUNCTION__, $alias, Str\format('vec<%s>', $inner));
  }

  public function vecOrDict(TAlias $alias, vec<string> $inner)[]: string {
    return static::fmt(
      __FUNCTION__,
      $alias,
      Str\format('vec_or_dict<%s>', Str\join($inner, ', ')),
    );
  }

  public function void(TAlias $alias)[]: string {
    return static::fmt(__FUNCTION__, $alias);
  }

  private static function fmt(
    string $function,
    TAlias $alias,
    string $repr = $function,
  )[]: string {
    return
      Str\format('(from %s: %s %s)', $function, $alias['alias'] ?? '_', $repr);
  }
}
