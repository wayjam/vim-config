# NeoVim Config

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![GitHub repo size](https://img.shields.io/github/repo-size/wayjam/vim-config)

Modern NeoVim config.

## Prerequisites

- NeoVim(0.8+)

## Installation

Clone this repo and put it to `~/.config/nvim` :

```sh
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/wayjam/vim-config.git nvim
```

**_Note_**: Symlink for "regular" vim: `ln -s ~/.config/nvim ~/.vim`

## Feature

### Plugin Manager

Using [packer.nvim](https://github.com/wbthomason/packer.nvim) as plugin manager.

Update Plugin(the plugins are not updated automatically):

```sh
:PackerSync
```

#### LSP && Dap && Formatter

Using the Neovim's built-in language server client with [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), and you can install lsp server with [Mason](https://github.com/williamboman/mason.nvim):

```
:Mason
```

### Complete

Configured nvim-cmp with [LusSnip](https://github.com/L3MON4D3/LuaSnip) and [friendly-snippets](https://github.com/rafamadriz/friendly-snippets).

## Customize

Lua file in `customize/before` will source before all pre-configured plugins,
Lua file in `customize/after` will source after all pre-configured plugins.

## Upgrade

```sh
cd ~/.config/nvim
git pull --ff --ff-only
```

## Troubleshooting

#### treesitter compile: `error trying to exec 'cc1plus': execvp: No such file or directory`

Just get g++ installed and then treesitter works.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://github.com/wayjam/vim-config/blob/master/LICENSE)
