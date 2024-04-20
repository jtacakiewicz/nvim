-- auto install packer if not installed
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
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
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
    use("morhetz/gruvbox")
    use("nordtheme/vim")
    use("shrikecode/kyotonight.vim")
    use("aserowy/tmux.nvim")
    --better escape mapping
    use{'jdhao/better-escape.vim', event = 'InsertEnter'}
    --highlight yanks
    use("machakann/vim-highlightedyank")
    --markdown live preview
    --use("instant-markdown/vim-instant-markdown")
    --obsidian integration
    use("epwalsh/obsidian.nvim")
    --tex live preview
    use("lervag/vimtex")
    --math
    use("jbyuki/quickmath.nvim")

    --slick line at the bottom
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    }
    --file browser
    use{"nvim-tree/nvim-tree.lua",
        tag = "nightly",
    }
    --slick line at the top
    use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

    use("mfussenegger/nvim-dap")
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    --to indent object selected
    use("michaeljsmith/vim-indent-object")
    use("lukas-reineke/indent-blankline.nvim")

    --better icons
    use("kyazdani42/nvim-web-devicons")

    use("folke/which-key.nvim")
    use {"folke/noice.nvim",
        requires = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    }
    --jumping between split screens
    use("tpope/vim-surround")
    --better folds
    use{"anuvyklack/pretty-fold.nvim",
       config = function()
          require("pretty-fold").setup()
       end
    }
    use { "anuvyklack/fold-preview.nvim",
       requires = "anuvyklack/keymap-amend.nvim",
       config = function()
          require("fold-preview").setup()
       end
    }
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
        "neovim/nvim-lspconfig",
    }

    use("rafamadriz/friendly-snippets")
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v<CurrentMajor>.*",
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    })

    --animations
    use({ 'echasnovski/mini.nvim', version = false})
    require('mini.align').setup()
    --require('mini.comment').setup()
    --require('mini.animate').setup()
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }


    --fuzzy finder mainly
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

    --file manager
    use("nvim-treesitter/nvim-treesitter")
    use {
    "princejoogie/chafa.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        "m00qek/baleia.nvim"
    },
    }
    use {'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    }

    if packer_bootstrap then
    require("packer").sync()
  end
end)
