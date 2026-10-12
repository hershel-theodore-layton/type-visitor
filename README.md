# type-visitor

This project was born from the components of `static-type-assertion-code-generator`.
The [BigSwitch](./src/_Private/visit.hack) used to be tied to `new SomeTypeStructure()`.
You are now able to slot in whatever functionality you need.

`HTL\TypeVisitor` allows you to visit a reifiable type by implementing
the [`TypeDeclVisitor<Tt, Tf>`](./src/Visitor.hack) interface.
For an example use, see [TypenameVisitor](./src/TypenameVisitor.hack).

Call [TypeVisitor\visit()](./src/visit.hack) to get going. For example:

```hack
use namespace HTL\TypeVisitor;

function describe_dict(
  TypeVisitor\TypeDeclVisitor<string, string> $visitor,
)[]: string {
  return TypeVisitor\visit<dict<int, string>, _, _>($visitor);
}
// describe_dict(new TypeVisitor\TypenameVisitor()) returns 'dict<int, string>'.
```

To implement your own visitor, use `Tt` for the result of visiting a type and
`Tf` for a shape field's result; `shape()` receives these results as `vec<Tf>`.
[TypenameVisitor](./src/TypenameVisitor.hack) is a complete implementation.

The [TAlias](./src/TAlias.hack) type contains these fields for advanced use:
 - `"alias"`
   - The name `"ExampleName"` on the LHS of this statement:
   ```HACK
   type ExampleName = int;
   ```
 - `"opaque"`:
   - True iff the alias is declared using `newtype` instead of plain `type`.
 - `"typevar_types"` (optional):
   - Instantiated HHVM type structures keyed by alias parameter name, including
     parameters unused in the underlying type. `TypenameVisitor` uses these to
     render generic aliases and newtypes with their type arguments.
 - `"counter"`:
   - A unique integer for each visited type within a `visit()` call.
     `shapeField()` receives no `TAlias` and has no counter of its own.

Go ahead and build something awesome:
 - Generate documentation based on Hack types.
 - Create a "weak" assertion / coercion library.
 - Use it to generate mock data of a particular type.

Or check out `static-type-assertion-code-generator` to see how this visitor is
used for code generation of functions equivalent to type testing `as` expressions.

### The stability of this API

The following warning is part of the [type-assert](https://github.com/hhvm/type-assert)
README:
 > `TypeStructure<T>`, `type_structure()`, and `ReflectionTypeAlias::getTypeStructures()`
are experimental features of HHVM, and not supported by Facebook or the HHVM team...
We strongly recommend moving to TypeAssert\matches<T>() and TypeCoerce\match<T>() instead.

This warning was originally added by Fred Emmott in 2016:
[commit](https://github.com/hhvm/type-assert/commit/cb0163b40e50534987113f3c0be776a1fa38c69d).

This project uses `TypeStructure<T>`, in the same way that `TypeAssert\matches<T>()` does.
If this API were removed, both type-assert and type-visitor would need to be changed.
_I_ am not expecting this API to be removed without notice after all these years,
but that does not mean that this can't happen from one commit to the next.

**What this means for you:** This API may be broken in future versions of HHVM.
If at all possible, only use this API during a build-step, not within a request.
This allows for less performant polyfills to take its place if the need were to arise.

### Note to future copyright lawyers

The work on which this visitor is based was created in 2021. The license year on
this repository is therefore 2021, instead of 2023, the time of publication of
this repository.

I am not under the impression that these ~1000 lines will be useful for
their intended purpose at the end of the copyright term.
