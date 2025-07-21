return {{
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = {'nvim-lua/plenary.nvim'},
    opts = {
        signs = false
    }
}, { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "bash", "json", "typescript", "javascript", "c", "diff", "html", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { 
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = {'ruby'}
        },
        indent = { 
          enable = true,
          disable = {'ruby'}
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- jumps to textobject if not on one
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}}
