---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    -- resize with arrow
    ["<C-Up>"] = { ":resize -2<CR>" },
    ["<C-Down>"] = { ":resize +2<CR>" },
    ["<C-Left>"] = { ":vertical resize +2<CR>" },
    ["<C-Right>"] = { ":vertical resize -1<CR>" },

    -- close nvim
    ["<leader>q"] = { ":qa<CR>", "Close nvim" },

    -- move lines
    ["<A-j>"] = { ":m .+1<CR>==" },
    ["<A-k>"] = { ":m .-2<CR>==" },
  },
}
-- more keybinds
M.dap = {
  n = {
    ["<leader>gb"] = { "<cmd> DapToggleBreakpoint <CR>" },
    ["<leader>gpr"] = {
      function()
        require("dap-python").test_method()
      end,
      "Run python test method",
    },
  },
}

-- more keybinds!

return M
