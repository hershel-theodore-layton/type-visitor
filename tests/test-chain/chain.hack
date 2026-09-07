/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\Project_UHOruXcLGGYc\GeneratedTestChain;

use namespace HTL\TestChain;
use type HTL\Pragma\Pragmas;

<<file: Pragmas(vec['PhaLinters', 'digest:1c08e2ec3b5e5377e435'])>>

async function tests_async(
  TestChain\ChainController<\HTL\TestChain\Chain> $controller,
)[defaults]: Awaitable<TestChain\ChainController<\HTL\TestChain\Chain>> {
  return $controller
    ->addTestGroup(\HTL\TypeVisitor\Tests\test_visitor_function_test<>)
    ->addTestGroup(\HTL\TypeVisitor\Tests\typename_visitor_test<>);
}
