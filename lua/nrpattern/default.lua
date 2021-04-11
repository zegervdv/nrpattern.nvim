local patterns = {
  ["(%d*)'h([%x_]+)"] = {
    base = 16,
    format = "%s'h%s",
    priority = 10,
    separator = {
      char = "_",
      group = 4,
    },
    filetypes = {"verilog", "systemverilog"},
  },
  ["(%d*)'d([%d_]+)"] = {
    base = 10,
    format = "%s'd%s",
    priority = 10,
    separator = {
      char = "_",
      group = 3,
    },
    filetypes = {"verilog", "systemverilog"},
  },
  ["(%d*)'b([01_]+)"] = {
    base = 2,
    format = "%s'b%s",
    priority = 10,
    separator = {
      char = "_",
      group = 4,
    },
    filetypes = {"verilog", "systemverilog"},
  },
  ["(0[xX])([%x]+)"] = {
    base = 16,
    format = "%s%s",
    priority = 99,
  },
  ["(0b([01]+))"] = {
    base = 2,
    format = "%s%s",
    priority = 99,
  },
  ["(-?%d+)"] = {
    base = 10,
    format = "%s%s",
    priority = 100,
  },
  ["(-?%d[%d_]+)"] = {
    base = 10,
    format = "%s%s",
    priority = 99,
    separator = {
      char = "_", 
      group = 3
    },
    filetypes = {"python", "verilog", "systemverilog", "php"},
  },
  ["(0)(%d+)"] = {
    base = 8,
    format = "%s%s",
    priority = 101,
  },
  [{"true", "false"}] = {
    priority = 10,
  }
}

return patterns
