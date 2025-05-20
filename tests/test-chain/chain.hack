/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\Project_UHOruXcLGGYc\GeneratedTestChain;

use namespace HTL\TestChain;

async function tests_async(
)[defaults]: Awaitable<TestChain\ChainController<TestChain\Chain>> {
  return TestChain\ChainController::create(TestChain\TestChain::create<>)
    ->addTestGroup(\HTL\TypeVisitor\Tests\test_visitor_function_test<>)
    ->addTestGroup(\HTL\TypeVisitor\Tests\typename_visitor_test<>);
}
