local Plugin = {'rose-pine/neovim'}

Plugin.name = "rose-pine"

Plugin.opts = {
    styles = {
        italic = false,
    },
}

Plugin.config = function(_, opts)
    require('rose-pine').setup(opts)
end

return Plugin
