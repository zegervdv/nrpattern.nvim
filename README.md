# Nrpattern

A Neovim plugin to expand the number formats supported to increment or
decrement.

**This plugin uses lua and therefore requires Neovim 0.5.**

## Details

In (Neo)vim you can increment or decrement values using the `<ctrl-a>` and `<ctrl-x>`
mappings. However, these only work for a limited set of formats:

 * Decimal: `1231`
 * Hexadecimal: `0xaaff`
 * Octal: `0755`
 * Binary: `0b110011`

But there are many more formats used by the various programming languages.

Supports repeating with `.` when `tpope/vim-repeat` is installed.

Separators are inserted in the value when one was already present in the value.
The separators are however inserted in fixed groups, regardless of the previous
location of the separators.

For example the value `32'hff_fff_ff7` will become `32'hffff_fff8`, because the
`group` setting for SystemVerilog hexadecimal values is set to 4.


## TODO

Currently this plugin only works for a limited set of formats:
  * Decimals: `1231`
  * Hexadecimal: `0xaaff`
  * SystemVerilog: `17'haabb` and `32'd123123`

The intent is to make the pattern for number representations flexible and
configurable so it will support any format in use.

Following topics are planned to be added:

  * Configurable patterns
  * Visual mode increments/decrements with repeating
  * Incremental mode: `g<ctrl-a>`
  * Keep original case, for now every value is lowercased
  * Negative numbers

If possible (harder problems):

  * Preserve original location of separators


## Thanks

Thanks to @smolck for the initial code snippet to start this plugin.

The `BigInteger.lua` file to enable support for large numbers (over 64 bits) is
copyrighted to @a-benlolo: [BigInteger.lua repository](https://github.com/A-Benlolo/BigInteger.lua).
