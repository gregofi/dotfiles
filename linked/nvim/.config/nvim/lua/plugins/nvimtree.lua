local Plugin = {'kyazdani42/nvim-tree.lua'}


local function on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "<leader>tt", api.tree.toggle)
end

Plugin.opts = {
    sort_by = "case_sensitive",
    view = {
        -- width = 60,
    },
    on_attach = on_attach,
    renderer = {
        indent_markers = {
            enable = true
        },
        group_empty = true,
    },
}

Plugin.dependencies = {
    {'kyazdani42/nvim-web-devicons'},
}

return Plugin
