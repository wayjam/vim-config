# Vim Config

### Prerequisites

- NeoVim or Vim(require 8.0)
- Python3
- Go(for vim-go)
- NodeJS and yarn(for coc.vim)

### Install

**_1._** Get config

Clone this repo and put it to `~/.config/nvim` :

```sh
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/wayjam/vim-config.git nvim
```

**_Note_**: Symlink for "regular" vim: `ln -s ~/.config/nvim ~/.vim`

**_2._** Providers

Execute `:checkhealth proviers` at vim for proviers status, and follow the output to install missing provider.

**_3._** coc.nvim & code completion

- NodeJS: `npm install -g yarn`
- Python: `pip3 install jedi`
- Rust: `rustup component add rls rust-analysis rust-src`
- C/C++: Follow <https://github.com/MaskRay/ccls/wiki/Install> and install ccls.

### Plugins

Using [Shougo/dein.vim](https://github.com/Shougo/dein.vim) as plugin manager.

Update Plugin(the plugins are not updated automatically):

```sh
:call dein#update()
```

### Customize your config

Create your config named `customize.vim` at the root of this repo, edit it and save.

### Upgrade

```sh
cd ~/.config/nvim
git pull --ff --ff-only
```

### Acknowledgements

- [rafi/vim-config](https://github.com/rafi/vim-config)
- [liuchengxu/space-vim](https://github.com/liuchengxu/space-vim)
