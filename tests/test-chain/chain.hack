/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\Project_UHOruXcLGGYc\GeneratedTestChain;

use namespace HTL\TestChain;

async function tests_async<T as TestChain\Chain>(
  TestChain\ChainController<T> $controller
)[defaults]: Awaitable<TestChain\ChainController<T>> {
  return $controller
    ->addTestGroup(\HTL\TypeVisitor\Tests\test_visitor_function_test<>)
    ->addTestGroup(\HTL\TypeVisitor\Tests\typename_visitor_test<>);
}
