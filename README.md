# static-type-assertion-code-generator-interfaces

This project contains the interface required for hooking into the
hershel-theodore-layton/static-type-assertion-code-generator machinery.

Before the release of v1.0, you could not use `from_type<T>()` with custom matchers.
`StaticTypeAssertionCodegen\from_type_with_visitor<T>($visitor)` is meant for
extension of the base rules in `static-type-assertion-code-generator`.

Go ahead and build something awesome:
 - Generate documentation based on Hack types.
 - Create a "weak" assertion / coercion code path.
 - Use it to generate mock data of a particular type.
