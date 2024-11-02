# type-visitor

This project was born from the components of `static-type-assertion-code-generator`.
The [BigSwitch](./src/_Private/visit.hack) used to be tied to `new SomeTypeStructure()`.
You are now able to slot in whatever functionality you need.

`HTL\TypeVisitor` allows you to visit a reifiable type by implementing
the [Visitor<Tt, Tf>`](./src//Visitor.hack) interface.
For an example use, see [TypenameVisitor](./src/TypenameVisitor.hack).

Call [TypeVisitor\visit()](./src/visit.hack) to get going.

The [TAlias](./src/TAlias.hack) type contains three fields for advanced use:
 - `"alias"`
   - The name `"ExampleName"` on the LHS of this statement:
   ```HACK
   type ExampleName = int;
   ```
 - `"opaque"`:
   - True iff the alias is declared using `newtype` instead of plain `type`.
 - `"counter"`:
   - A unique integer for each call to your visitor functions.
   - This sequence starts at `1` and increases with each call to `$visitor->x()`.

**Warning for users on hhvm 4.102 through 4.108.**

At some point between hhvm version 4.102 and 4.108,
hhvm changed the kind of `enum class` from `enum` to `class`.
This means that `->enum()` will be called instead of `->class()`.
If your visitors need to have consistent behavior on all supported hhvm versions,
you must add a reflection based check at the top of `function enum(...)` and
call `->class()` if the argument is a `classname` of an `enum class`.

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

This warning was orignally added by Fred Emmott in 2016:
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
