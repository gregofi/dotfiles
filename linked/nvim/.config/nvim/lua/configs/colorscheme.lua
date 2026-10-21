-- set default colorscheme
vim.cmd('colorscheme rose-pine')
vim.o.background = 'dark'


local colorschemes = {
    -- theme does not understand o.background
    "rose-pine",
    vim.o.background == 'dark' and "github_dark" or "github_light",
    "vscode",
}

local cs_index = 0
local startup = true
local function switch_scheme()
    cs_index = cs_index % #colorschemes + 1
    vim.cmd.colorscheme(colorschemes[cs_index])
    if not startup then
        vim.notify("Switched to colorscheme: " .. colorschemes[cs_index], vim.log.levels.INFO, { title = "Colorscheme" })
    end
    startup = false
end

-- Cycle through preferred colorschemes
vim.keymap.set("n", "<leader>cs", switch_scheme, { desc = "Cycle colorscheme" })
switch_scheme()
