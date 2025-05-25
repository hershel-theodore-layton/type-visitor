/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\_Private;

use namespace HH\Lib\{C, Str};
use type HTL\TypeVisitor\TypeDeclVisitor;

function visit<Tt, Tf>(
  TypeDeclVisitor<Tt, Tf> $visitor,
  CleanTypeStructure $s,
  inout int $counter,
)[]: Tt {
  ++$counter;
  $kind = TypeStructureKind::assert($s['kind']);
  $alias = shape(
    'alias' => $s['alias'] ?? null,
    'counter' => $counter,
    'opaque' => $s['opaque'] ?? false,
  );

  if ($s['nullable'] ?? false) {
    $s['nullable'] = false;
    return $visitor->nullable($alias, visit($visitor, $s, inout $counter));
  }

  switch ($kind) {
    case TypeStructureKind::OF_ARRAY:
      // A leftover enumeration value from long ago.
      return $visitor->unsupportedType('array');
    case TypeStructureKind::OF_ARRAYKEY:
      return $visitor->arraykey($alias);
    case TypeStructureKind::OF_BOOL:
      return $visitor->bool($alias);
    case TypeStructureKind::OF_CLASS:
      $classname = $s['classname'] ?? null;
      $generics = $s['generic_types'] ?? vec[];

      if ($classname is null) {
        return $visitor->panic('Class without classname.');
      }

      return $visitor->class($alias, $classname, map_with_key_and_counter(
        $generics,
        inout $counter,
        (inout $counter, $_, $g) ==> visit($visitor, clean($g), inout $counter),
      ));
    case TypeStructureKind::OF_DARRAY:
      // Just use `dict<_, _>`, it is identical.
      return $visitor->unsupportedType('darray<_, _>');
    case TypeStructureKind::OF_DICT:
      $generics = $s['generic_types'] ?? vec[];
      if (C\count($generics) !== 2) {
        return $visitor->panic(
          Str\format('Dict type with %d type parameters', C\count($generics)),
        );
      }
      return $visitor->dict(
        $alias,
        visit($visitor, clean($generics[0]), inout $counter),
        visit($visitor, clean($generics[1]), inout $counter),
      );
    case TypeStructureKind::OF_DYNAMIC:
      return $visitor->dynamic($alias);
    case TypeStructureKind::OF_ENUM:
      $enum_name = $s['classname'] ?? null;

      if ($enum_name is null) {
        return $visitor->panic('Enum without classname.');
      }

      return $visitor->enum($alias, $enum_name);
    case TypeStructureKind::OF_FLOAT:
      return $visitor->float($alias);
    case TypeStructureKind::OF_FUNCTION:
      return $visitor->unsupportedType('(function(...): ...)');
    case TypeStructureKind::OF_GENERIC:
      return $visitor->unsupportedType('[[generic]]');
    case TypeStructureKind::OF_INT:
      return $visitor->int($alias);
    case TypeStructureKind::OF_INTERFACE:
      $classname = $s['classname'] ?? null;
      $generics = $s['generic_types'] ?? vec[];

      if ($classname is null) {
        return $visitor->panic('Interface without classname.');
      }

      return $visitor->interface($alias, $classname, map_with_key_and_counter(
        $generics,
        inout $counter,
        (inout $counter, $_, $g) ==> visit($visitor, clean($g), inout $counter),
      ));
    case TypeStructureKind::OF_KEYSET:
      $generics = $s['generic_types'] ?? vec[];

      if (C\count($generics) !== 1) {
        return $visitor->panic(
          Str\format('Keyset type with %d type parameters', C\count($generics)),
        );
      }

      return $visitor->keyset(
        $alias,
        visit($visitor, clean($generics[0]), inout $counter),
      );
    case TypeStructureKind::OF_MIXED:
      return $visitor->mixed($alias);
    case TypeStructureKind::OF_NONNULL:
      return $visitor->nonnull($alias);
    case TypeStructureKind::OF_NORETURN:
      return $visitor->noreturn($alias);
    case TypeStructureKind::OF_NOTHING:
      return $visitor->nothing($alias);
    case TypeStructureKind::OF_NULL:
      return $visitor->null($alias);
    case TypeStructureKind::OF_NUM:
      return $visitor->num($alias);
    case TypeStructureKind::OF_RESOURCE:
      return $visitor->resource($alias);
    case TypeStructureKind::OF_SHAPE:
      $fields = $s['fields'] ?? null;

      if ($fields is null) {
        return $visitor->panic('Shape without field information.');
      }

      return $visitor->shape(
        $alias,
        map_with_key_and_counter($fields, inout $counter, (
          inout $counter,
          $name,
          $t,
        ) ==> {
          $t = clean($t);
          $const = $t['is_cls_cns'] ?? false;
          $optional = $t['optional_shape_field'] ?? false;

          return $visitor->shapeField(
            $alias['alias'],
            $name,
            $const,
            $optional,
            visit($visitor, $t, inout $counter),
          );
        }),
        $s['allows_unknown_fields'] ?? false,
      );

    case TypeStructureKind::OF_STRING:
      return $visitor->string($alias);
    case TypeStructureKind::OF_TRAIT:
      $classname = $s['classname'] ?? null;
      $generics = $s['generic_types'] ?? vec[];

      if ($classname is null) {
        return $visitor->panic('Trait without classname.');
      }

      return $visitor->trait($alias, $classname, map_with_key_and_counter(
        $generics,
        inout $counter,
        (inout $counter, $_, $g) ==> visit($visitor, clean($g), inout $counter),
      ));
    case TypeStructureKind::OF_TUPLE:
      $generics = $s['elem_types'] ?? vec[];

      if (C\is_empty($generics)) {
        return $visitor->panic('Tuple without type parameters.');
      }

      return $visitor->tuple(
        $alias,
        map_with_key_and_counter(
          $generics,
          inout $counter,
          (inout $counter, $_, $g) ==>
            visit($visitor, clean($g), inout $counter),
        ),
      );
    case TypeStructureKind::OF_UNRESOLVED:
      return $visitor->unsupportedType('unresolved');
    case TypeStructureKind::OF_VARRAY:
      // Just use `vec<_>`, it is identical.
      return $visitor->unsupportedType('varray<_>');
    case TypeStructureKind::OF_VARRAY_OR_DARRAY:
      // Just use `vec_or_dict<_>`, it is identical.
      return $visitor->unsupportedType('varray_or_darray<_>');
    case TypeStructureKind::OF_VEC:
      $generics = $s['generic_types'] ?? vec[];

      if (C\count($generics) !== 1) {
        return $visitor->panic(
          Str\format('Vec type with %d type parameters', C\count($generics)),
        );
      }

      return $visitor->vec(
        $alias,
        visit($visitor, clean($generics[0]), inout $counter),
      );
    case TypeStructureKind::OF_VEC_OR_DICT:
      // Not checking the generic parameter count on purpose.
      // This type can be instantiated with any number of generic parameters.
      return $visitor->vecOrDict(
        $alias,
        map_with_key_and_counter(
          $s['generic_types'] ?? vec[],
          inout $counter,
          (inout $counter, $_, $g) ==>
            visit($visitor, clean($g), inout $counter),
        ),
      );
    case TypeStructureKind::OF_VOID:
      return $visitor->void($alias);
    default:
      if ($kind === TypeStructureKind::OF_XHP) {
        return $visitor->unsupportedType('xhp');
      } else if ($kind === 31) {
        return $visitor->unsupportedType('OF_UNION');
      } else if ($kind === 32) {
        return $visitor->unsupportedType('OF_RECURSIVE_UNION');
      } else if ($kind === 33) {
        return $visitor->unsupportedType('OF_CLASS_PTR');
      } else if ($kind === 34) {
        return $visitor->unsupportedType('OF_CLASS_OR_CLASSNAME');
      } else {
        return $visitor->unsupportedType('UNKNOWN_TYPE:' . $kind);
      }
  }
}
