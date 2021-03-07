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
  * Insert/re-insert exising separators. E.g. `32'haabb_ccdd`
  * Keep original case, for now every value is lowercased
  * Binary formatting
  * Negative numbers


## Thanks

Thanks to @smolck for the initial code snippet to start this plugin.
