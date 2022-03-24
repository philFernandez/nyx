# Structure Overview

To start it would be good to set some goals or some nice to haves for our configuration.

- Organized with separation of concern's
  - Easy to audit configuration overtime
- Reload configuration without leaving neovim
- Bootstrap plugins with packer if not installed
- Save parts of the editor's state when changes
- Use `XDG_CACHE_HOME` and `XDG_DATA_HOME` for relevant additional files
- Platform agnostic (as much as possible)

To start with if you are unfimiliar with the file structure of vim/neovim's configuration/plugins then it is
recommended to check the **help** docs of neovim `:help runtimepath` for more information.

Here is an overview of the important file and folders that our resulting config will look like:

```text
.
├── init.lua              | config entriy point
└── lua/                  |
    └── eden/             | A namespace for my user config
        ├── core/         | keymap and autocmd apis + core defitiions
        ├── fn/           | Used defined function to call from mappings
        ├── lib/          | Define libraries and utility functions
        ├── modules/      | plugin definitions and configuration
        ├── user/         | user neovim settings, mapping and autocmds
        ├── bootstrap.lua | bootstrap of env and plugins
        └── main.lua      | main entry point after env has been bootstrapped
```

> Note: `eden` is used as a namespace for my user. When refering to `eden` in this book please refer to the namespace
> you have chosen. A namespace should be unique and not collide with any plugins that you will use.

To start we will create some empty files and folders that will be used later on. For my

```bash
# ~/.config
mkdir nvim
cd nvim

mkdir -p after/ftplugin ftplugin lua/eden
touch init.lua
cd lua/eden

mkdir core modules user
touch {bootstrap,main}.lua
```

To help follow along and make working with base neovim easier we will temporarly add these lines to our `init.lua`
file.

```lua
-- init.lua
vim.opt.clipboard = "unnamedplus" -- This lets us use the system clipboard to copy and paste

-- Set some default editor settings for writing lua
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
```

