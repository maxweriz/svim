-- ~/.config/nvim/init.lua

-- =========================
-- Plugin Manager (packer)
-- =========================
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- packer manages itself

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- LSP support
  use 'neovim/nvim-lspconfig'

  -- Neo-tree (modern file explorer)
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
      "MunifTanjim/nui.nvim",
    }
  }

  -- Bufferline (tabline plugin)
  use {
    'akinsho/bufferline.nvim',
    requires = 'nvim-tree/nvim-web-devicons'
  }

end)

-- =========================
-- Treesitter Config
-- =========================
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "lua", "vim", "query" },
  highlight = { enable = true },
  indent = { enable = true }
}

-- =========================
-- LSP Config (Rust)
-- =========================
local lspconfig = require'lspconfig'

lspconfig.rust_analyzer.setup{
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    }
  }
}

-- =========================
-- Neo-tree Config
-- =========================
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
  close_if_last_window = false, -- keep Neo-tree open
  filesystem = {
    follow_current_file = true, -- highlight the file you're editing
    hijack_netrw_behavior = "open_default", -- replaces netrw
  }
})

-- Leader key
vim.g.mapleader = " "

-- Keymap: Space + e (in editor) → focus filesystem tree
vim.keymap.set('n', '<leader>e', ':Neotree focus filesystem<CR>', { noremap = true, silent = true })

-- Keymap: Esc (in Neo-tree) → jump back to previous window (editor)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    vim.keymap.set('n', '<Esc>', '<C-w>p', { buffer = true, noremap = true, silent = true })
  end
})

-- Ctrl+n toggles Neo-tree
vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })

-- =========================
-- Bufferline Config
-- =========================
require("bufferline").setup{}

-- Tab navigation keymaps
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Use the system clipboard for all yank, delete, change, put operations
vim.opt.clipboard = "unnamedplus"
