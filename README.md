# NEOVIM Configuration

This repo contains a history and current configuration of my nvim config.

Clone to `~/.config/nvim` (MacOS or Linus) or `%LOCALAPPDATA%\nvim` (Windows).

Configuration is heavily inspired by chris' repo https://github.com/LunarVim/Neovim-from-scratch and his excellent tutorial https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ

## Nerd Fonts

Install nerdfont with brew, e.g. run

```
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install --cask font-caskaydia-cove-nerd-font
brew install --cask font-victor-mono-nerd-font
```

or install fonts manually.

Then set it as the active font in iTerm 2 or Windows Terminal App and enable font ligatures.

## Telescope

Install [ripgrep](https://github.com/BurntSushi/ripgrep) to have .gitignore respected and overall much better experience.

## TreeSitter and Windows

Installing nvim-treesitter under Windows gave me quite a bit of a headache. Here's what worked for me:

- Install MinGW-x64 and add the `bin/` to PATH

or

- Install Visual Studio 2019 `x64 Native Tools Command Prompt for VS 2019` and run them.
- In the prompt that appears, navigate to the `[nvim-dir]\bin` and run `nvim-qt.exe`.
- Wait until Treesitter has compiled.
- Now nvim will run with Treesitter from everywhere!

## Improve Startup

- https://alpha2phi.medium.com/neovim-for-beginners-performance-95687714c236

## Important Bindings

- `<C-a>`: Select All

- `<C-p>`: find files
- `<C-f>`: find in, i.e. live-grep

- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: navigate splits 
- `<A-Up, Left, Right, Down>`: resize splits 
- `<leader>h`, `<leader>l`: navigate buffers
- `gl`: lsp diagnostics

- `gd`: goto definitions
- `gr`: go to references
- `gn`: rename symbol
- `K`: hover and get information about symbol (vs. `<C-k>`, check `handlers.lua`)

- `gcc` / `gc`: comment (line mode)
- `gbc` / `gb`: comment (block mode)

- `<leader>s`: remove search highlighting
- `<leader>q`: close buffer
- `<leader>i2` / `<leader>i4`: set indentation depth
- `<leader>gb`: toggle git blame

## Important Commands

- `TSUpdate`: Update all plugins
- `LspInstallInfo`: install lsp servers
- `LspInfo`: see currently attached lsp servers

## Other Interesting Plugins to Check

- https://github.com/sslivkoff/vim-scroll-barnacle
- https://github.com/folke/trouble.nvim
- https://github.com/tpope/vim-fugitive
- https://github.com/f-person/git-blame.nvim
- nvim-telescope/telescope-file-browser.nvim
