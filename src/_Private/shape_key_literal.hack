/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\_Private;

use namespace HH\Lib\Str;
use function ord;

/** Encode a string as one literal, never as a concatenation expression. */
function shape_key_literal(string $key)[]: string {
  $quoted = '"';
  $needs_escapes = false;
  for ($i = 0; $i < Str\length($key); $i++) {
    $byte = ord($key[$i]);
    if ($byte < 32 || $byte >= 127) {
      $needs_escapes = true;
      $quoted .= Str\format('\\x%02x', $byte);
    } else {
      $char = $key[$i];
      if ($char === '\\' || $char === '"' || $char === '$') {
        $quoted .= '\\';
      }
      $quoted .= $char;
    }
  }
  if ($needs_escapes) {
    return $quoted.'"';
  }
  return "'".Str\replace(Str\replace($key, '\\', '\\\\'), "'", "\\'")."'";
}
