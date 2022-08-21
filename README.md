# NEOVIM Configuration

This repo contains a history and current configuration of my nvim config.

Clone to `~/.config/nvim`

Configuration is heavily inspired by chris' repo https://github.com/LunarVim/Neovim-from-scratch and his excellent tutorial https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ

## Nerd Fonts

Install nerdfont with brew, e.g. run

```
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install --cask font-caskaydia-cove-nerd-font
brew install --cask font-victor-mono-nerd-font
```

Then set it as the active font in iTerm 2 and enable font ligatures.

## Important Bindings

`<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: navigate splits 
`<A-Up, Left, Right, Down>`: resize splits 
`<leader>h`, `<leader>l`: navigate buffers
`gl`: lsp diagnostics

## Important Commands

`LspInstallInfo`: install lsp servers
`LspInfo`: see currently attached lsp servers
