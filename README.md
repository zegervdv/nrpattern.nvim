# Nrpattern

A Neovim plugin to expand the number formats supported to increment or
decrement.

**This plugin requires Neovim 0.5.**

![preview](https://i.imgur.com/yKIntlk.gif)

## Details

In (Neo)vim you can increment or decrement values using the `<ctrl-a>` and `<ctrl-x>`
mappings. However, these only work for a limited set of formats:

 * Decimal: `1231`
 * Hexadecimal: `0xaaff`
 * Octal: `0755`
 * Binary: `0b110011`

But there are many more formats used by the various programming languages in
existance today, and likely many more will follow.

This plugin allows you to define custom patterns.

### Features

  * Custom formats and patterns
  * Value separators (e.g. `123_1231` for python or php)
  * Repeat with `.` (requires `tpope/vim-repeat`)
  * Arbitrary large number support
  * Cyclic patterns: toggle between words


## Installation

 * vim-plug

``` vimscript
Plug 'zegervdv/nrpattern.nvim'
lua require"nrpattern".setup()
```

 * packer.nvim

``` lua
use {
  'zegervdv/nrpattern.nvim',
  config = function()
    -- Basic setup
    -- See below for more options
    require"nrpattern".setup()
  end,
}
```

## Configuration

Nrpattern.nvim comes with a couple of default patterns installed, but you can
add more, disable some or change their options.

``` lua
-- Get the default dict of patterns
local patterns = require"nrpattern.default"

-- The dict uses the pattern as key, and has a dict of options as value.
-- To add a new pattern, for example the VHDL x"aabb" format.
patterns['()x"(%x+)"'] = {
  base = 16, -- Hexadecimal
  format = '%sx"%s"', -- Output format
  priority = 15, -- Determines order in pattern matching
}

-- Change a default setting:
patterns["(%d*)'h([%x_]+)"].separator.group = 8

-- Remove a pattern
patterns["(%d*)'h([%x_]+)"] = nil

-- Add a cyclic pattern (toggles between yes and no)
patterns[{"yes", "no"}] = {priority = 5}

-- Call the setup to enable the patterns
require"nrpattern".setup(patterns)
```

### Options

The pattern must have two capture groups. The first is the prefix and may be an
empty match. 
The second must match the value with any possible separators.

For example, to match `32'haaaa_bbbb` as a hexadecimal value, you need the
pattern `"(%d*)'h([%x_]+)"`:
  * `(%d*)`: The prefix capture group, matches zero or more digits
  * `'h`: Literally match this string
  * `([%x_]+)`: The value capture group, match any hexadecimal character or `_`
  once or more

If the pattern is a list, it matches each word in the list and cycles over the
opions. For example you can toggle between `true` or `false`, or `in` and
`out`.
When the list has more than two options it cycles through the list in order of
definition. E.g. for a list of `{'one', 'two', 'three'}`, when incrementing
over the word `one` will update to `two`, then to `three`.

For every pattern you can set some options:

  * `base` : The base of the format, e.g. 10 for decimal, 16 for hex
  * `format` : The output format, must have 2 string patterns ('%s'), first is
  prefix (and may be empty), second is new value
  * `priority` : Order in which to match patterns, lower is earlier. See
  [default.lua](https://github.com/zegervdv/nrpattern.nvim/blob/master/lua/nrpattern/init.lua) for default values.
  * `separator` : Optional dict, for digit separators in pattern
    * `char` : character to insert as separator
    * `group` : How many digits to group (e.g., add a `,` every 3 digits)
  * `filetypes`: Optional list, filetypes to enable the pattern for

Separators are inserted in the value when one was already present in the value.
The separators are however inserted in fixed groups, regardless of the previous
location of the separators.

For example the value `32'hff_fff_ff7` will become `32'hffff_fff8`, because the
`group` setting for SystemVerilog hexadecimal values is set to 4.

## Mappings

By default `<ctrl-a>`, `<ctrl-x>`, and `g<ctrl-a>` and `g<ctrl-x>` are remapped
to nrpattern. If you want to avoid this you can set `g:nrpattern_no_mapping`.

```
-- vimscript
let g:nrpattern_no_mapping = 1

-- lua
vim.g.nrpattern_no_mapping = 1
```

To map them manually:
```
  nmap <C-a> <Plug>(PatternIncrement)
  nmap <C-x> <Plug>(PatternDecrement)
  vmap <C-a> <Plug>(PatternRangeIncrement)
  vmap <C-x> <Plug>(PatternRangeDecrement)
  vmap g<C-a> <Plug>(PatternMultIncrement)
  vmap g<C-x> <Plug>(PatternMultDecrement)
```

## TODO

Following topics are planned to be added:

  * Keep original case, for now every value is lowercased
  * Keep leading zeros

If possible (harder problems):

  * Preserve original location of separators


## Thanks

Thanks to @smolck for the initial code snippet to start this plugin.

The `BigInteger.lua` file to enable support for large numbers (over 64 bits) is
copyrighted to @a-benlolo: [BigInteger.lua repository](https://github.com/A-Benlolo/BigInteger.lua).
