-- auto install packer if not installedmini
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins_setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
  return
end

-- add list of plugins to install
return packer.startup(function(use)
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim") -- lua functions that many plugins use
    --list of plugins

    --colorscheme
    use("gbprod/nord.nvim")

    --tmux yank and movement
    use("aserowy/tmux.nvim")

    --better escape mapping
    use{'jdhao/better-escape.vim', event = 'InsertEnter'}
    --highlight yanks
    use("machakann/vim-highlightedyank")

    --slick line at the bottom
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    }
    --slick line at the top
    use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

    use{'nvim-neotest/nvim-nio'}
    use{"mfussenegger/nvim-dap"}
    use{"rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    --to indent object selected
    use("michaeljsmith/vim-indent-object")

    --better icons
    use("kyazdani42/nvim-web-devicons")

    -- use("tpope/vim-surround")
    --code completion
    use{"hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        }
    }

    --use {"ray-x/lsp_signature.nvim",
    --   config = function()
    --      require("lsp_signature").setup{}
    --   end
    --}

    --easy lsp and dap servers
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "neovim/nvim-lspconfig",
    }

    use{
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v<CurrentMajor>.*",
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    }

    use{ 'echasnovski/mini.nvim', version = false}

    use{ 'numToStr/Comment.nvim'}

    use {'lewis6991/gitsigns.nvim'}


    --notetaking
    use {
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    }
    use {
        "epwalsh/obsidian.nvim",
        tag = "*",  -- recommended, use latest release instead of latest commit
        requires = {
            "nvim-lua/plenary.nvim",
        },
    }

    --fuzzy finder mainly
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" } -- dependency for better sorting performance
    use { "nvim-telescope/telescope.nvim", branch = "0.1.x" } -- fuzzy finder
    use { "nvim-telescope/telescope.nvim", branch = "0.1.x" } -- fuzzy finder
    use { "debugloop/telescope-undo.nvim" }


    use ("nvim-treesitter/nvim-treesitter")
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    }
    --file manager
    use {'stevearc/oil.nvim',
        requires = { "nvim-tree/nvim-web-devicons" },
    }
    --leetcode
    -- use {
    --     "kawre/leetcode.nvim",
    --     build = ":TSUpdate html",
    --     requires = {
    --         "nvim-telescope/telescope.nvim",
    --         "nvim-lua/plenary.nvim", -- required by telescope
    --         "MunifTanjim/nui.nvim",
    --
    --         -- optional
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     opts = {
    --         -- configuration goes here
    --     },
    -- }
    --colorscheme
    use {"m4xshen/hardtime.nvim",
        requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    }

    if packer_bootstrap then
    packer.sync()
  end
end)
