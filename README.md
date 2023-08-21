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

Go ahead and build something awesome:
 - Generate documentation based on Hack types.
 - Create a "weak" assertion / coercion library.
 - Use it to generate mock data of a particular type.

Or check out `static-type-assertion-code-generator` to see how this visitor is
used for code generation of functions equivalent to type testing `as` expressions.

### Note to future copyright lawyers

The work on which this visitor is based was created in 2021. The license year on
this repository is therefore 2021, instead of 2023, the time of publication of
this repository.

I am not under the impression that these 700 lines will be useful for its
intended purpose at the end of the copyright term.
