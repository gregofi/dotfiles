--- Copies: "relative/path/to/file Lstart-end" into system clipboard
vim.keymap.set("v", "<leader>as", function()
  -- relative path to current working directory
  local file = vim.fn.expand("%")

  -- visual selection line numbers
  local l1 = vim.fn.line("'<")
  local l2 = vim.fn.line("'>")

  -- build string
  local text = string.format("%s:%d-%d", file, l1, l2)

  -- write to clipboard
  vim.fn.setreg("+", text)

    -- leave visual mode without modifying text
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "n",
    false
  )

  vim.notify("Current selection location was copied to clipboard")
end, { silent = true })

