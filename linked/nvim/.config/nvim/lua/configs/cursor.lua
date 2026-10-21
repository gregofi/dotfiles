
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line"

-- Causes line highligth to only be in the currently opened buffer
local cursorline_group = vim.api.nvim_create_augroup("CursorLineOnlyActiveWindow", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = cursorline_group,
    callback = function()
        vim.wo.cursorline = true
    end,
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = cursorline_group,
    callback = function()
        vim.wo.cursorline = false
    end,
})

