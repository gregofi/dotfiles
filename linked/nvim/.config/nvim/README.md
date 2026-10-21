# Neovim

## Requirements

[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) needs the `tree-sitter` CLI to build parsers.

```sh
cargo install --locked tree-sitter-cli
```

Make sure `~/.cargo/bin` is in `PATH`.

## Lazy nvim - Plugin manager

We use the [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management. Some heads up:

Plugins often use the

```lua
require('plugin').setup({
    opts...
})
```

idiom.
The packer uses similar thing.
You can specify the `opts` table, which causes packer to call the `setup` function with the `opts` table that you provided.

You can also specify `config` function, which will be called on the plugin load.