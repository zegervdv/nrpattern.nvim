local patterns = {
  ["(%d*)'h([%x_]+)"] = {
    base = 16,
    format = "%s'h%s",
    priority = 10,
    separator = {
      char = "_",
      group = 4,
    },
  },
  ["(%d*)'d([%d_]+)"] = {
    base = 10,
    format = "%s'd%s",
    priority = 10,
    separator = {
      char = "_",
      group = 3,
    },
  },
  ["(%d*)'b([01_]+)"] = {
    base = 2,
    format = "%s'b%s",
    priority = 10,
    separator = {
      char = "_",
      group = 4,
    },
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
  ["(0)(%d+)"] = {
    base = 8,
    format = "%s%s",
    priority = 101,
  },
}

return patterns
