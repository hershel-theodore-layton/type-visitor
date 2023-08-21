/** type-visitor is MIT licensed, see /LICENSE. */
namespace HTL\TypeVisitor\_Private;

use namespace HH\Lib\Str;

/**
 * var_export_pure is not available in all supported hhvm versions.
 * This is a polyfill for hhvm 4.123 and below.
 *
 * Tested:
 * ```
 * $str = \random_bytes($ENTER_SIZE_HERE);
 * \fb_utf8ize(inout $str);
 * invariant(
 *   string_export($str) === var_export_pure($str),
 *   "%s !== %s\n%s",
 *   \bin2hex(string_export($str)),
 *   \bin2hex(\var_export_pure($str)),
 *   $str,
 * );
 * ```
 */
function string_export(string $string)[]: string {
  return
    Str\replace_every($string, dict['\\' => '\\\\', "'" => "\'"]) |> "'".$$."'";
}
