# Vim Config

> It only supports NeoVim now.

### Preparation

#### Get Config

Clone this repo and put it to `~/.config/nvim`

```sh
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/wayjam/vim-config.git nvim
```

Before you starting vim, please follow the guide below.

#### For Providers

Execute `:checkhealth proviers` at vim for proviers status.

```sh
# python2 provider
pip2 install pynvim
# python3 provider
pip3 install pynvim
# nodejs provider
npm install -g neovim
```

#### For coc.nvim

```sh
# 1. install NodeJS
# 2. install yarn
npm install -g yarn
```

- Go: `:GoInstallBinaries`
- Python: `pip3 install jedi`
- Rust: `rustup component add rls rust-analysis rust-src`
- C/C++: Follow <https://github.com/MaskRay/ccls/wiki/Install> and install ccls.

### Plugins

Using [Shougo/dein.vim](https://github.com/Shougo/dein.vim) as plugin manager.

Update Plugin(The plugins are not updated automatically.):

```
:call dein#update()
```

### Acknowledgements

- [rafi/vim-config](https://github.com/rafi/vim-config)
- [liuchengxu/space-vim](https://github.com/liuchengxu/space-vim)
