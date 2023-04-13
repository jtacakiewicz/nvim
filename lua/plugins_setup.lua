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
    use("christoomey/vim-tmux-navigator")
    --highlight yanks
    use("machakann/vim-highlightedyank")
    --markdown live preview
    use("instant-markdown/vim-instant-markdown")
    --tex live preview
    use("lervag/vimtex")

    --slick line at the bottom
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    }

    use("mfussenegger/nvim-dap")
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    --aligning 
    use("junegunn/vim-easy-align")
    --to indent object selected
    use("michaeljsmith/vim-indent-object")
    use("lukas-reineke/indent-blankline.nvim")

    --file browser
    use("nvim-tree/nvim-tree.lua")
    --better icons
    use("kyazdani42/nvim-web-devicons")

    use("folke/which-key.nvim")
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
    use("neovim/nvim-lspconfig")-- Configurations for Nvim LSP
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("rafamadriz/friendly-snippets")
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v<CurrentMajor>.*",
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    })


    
    --fuzzy finder mainly
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
    
    --file manager
    use({
        "nvim-treesitter/nvim-treesitter",
        commit = "408d088",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- ensure_installed = "maintained",
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                    persist_queries = false, -- Whether the query persists across vim sessions
                },
            })
        end,
    })
    use({"jackMort/ChatGPT.nvim",
        config = function()
          require("chatgpt").setup({
                welcome_message = "I know now why you cry, but it’s something I can never do."
            -- optional configuration
          })
        end,
        requires = {
          "MunifTanjim/nui.nvim",
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope.nvim"
        }
    })
    

    if packer_bootstrap then
    require("packer").sync()
  end
end)
