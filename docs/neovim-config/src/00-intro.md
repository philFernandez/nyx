# Introduction

**From Neovim's [Charter](https://neovim.io/charter/):**

> Neovim is a Vim-based text editor engineered for extensibility and usability, to encourage new applications and contributions.

One of the **key** words from this statement is the word `extensibility`. Neovim `0.5` introduced `lua` as a first-class
scripting alternative to `vimscript`. With this addition neovim was changed (in my mind) from just a text editor that
was customizable to a platform/programming language for editing text. Neovim by itself can be thought of as a languages
standard library and plugins as external libraries or dependencies. Your neovim configuration is the actual program that
you write to conform to what you think an editor should be like and what suites your workflow. Your `init.lua` file
could be thought of as the `main` function of your program. This is an interesting way of thinking about your neovim
configuration. This is the approach that this book will follow.

## Resources

Here are a list of some good resources to help you on your neovim journey. This book will assume that you have some
understanding of lua (it is a small language) and understand vim and its modal system.

- [nanotree/nvim-lua-guide](https://github.com/nanotee/nvim-lua-guide)
  - This is **the** guide for getting started writing lua in neovim.
- [Offical lua 5.1 reference](https://www.lua.org/manual/5.1/)
  - This is the offical reference for lua 5.1 which neovim currently uses
- [Quick lua guide](https://www.tutorialspoint.com/lua/lua_quick_guide.htm)
  - Lua is a small language and this is a quick guide on the basics
- [Lua metatables](https://ebens.me/post/lua-metatables-tutorial/)
  - Not necessary to know but unlocks some of the power of lua and its table structure
- [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)
  - List of neovim plugins by category
