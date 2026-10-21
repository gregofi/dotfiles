local Plugin = {
    'folke/lazydev.nvim',
}

Plugin.ft = 'lua'

Plugin.opts = {
    library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
}

return Plugin
