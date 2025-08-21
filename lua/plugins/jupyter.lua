return {
  -- Image rendering support for plots and rich output
  {
    '3rd/image.nvim',
    dependencies = { 'vhyrro/luarocks.nvim' },
    ft = { 'python', 'markdown' },
    opts = {
      backend = 'kitty',
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'markdown', 'vimwiki', 'quarto' },
        },
      },
      max_width = 100,
      max_height = 12,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    },
  },

  -- Seamless Jupyter notebook file conversion
  {
    'GCBallesteros/jupytext.nvim',
    build = 'pip3 install jupytext',
    config = function()
      require('jupytext').setup {
        style = 'percent',
        output_extension = 'auto',
        force_ft = 'python',
      }
    end,
  },

  -- Enhanced notebook navigation and cell management
  -- {
  --   'GCBallesteros/NotebookNavigator.nvim',
  --   dependencies = {
  --     'echasnovski/mini.comment',
  --     'anuvyklack/hydra.nvim',
  --   },
  --   ft = { 'python', 'markdown' },
  --   keys = {
  --     -- Cell navigation
  --     {
  --       ']h',
  --       function()
  --         require('notebook-navigator').move_cell 'd'
  --       end,
  --       desc = 'Next cell',
  --     },
  --     {
  --       '[h',
  --       function()
  --         require('notebook-navigator').move_cell 'u'
  --       end,
  --       desc = 'Previous cell',
  --     },
  --     {
  --       ']j',
  --       function()
  --         require('notebook-navigator').move_cell 'd'
  --       end,
  --       desc = 'Next cell',
  --     },
  --     {
  --       '[j',
  --       function()
  --         require('notebook-navigator').move_cell 'u'
  --       end,
  --       desc = 'Previous cell',
  --     },

  --     -- Cell execution
  --     {
  --       '<leader>jx',
  --       function()
  --         require('notebook-navigator').run_cell()
  --       end,
  --       desc = 'Run cell',
  --     },
  --     {
  --       '<leader>jX',
  --       function()
  --         require('notebook-navigator').run_and_move()
  --       end,
  --       desc = 'Run cell and move',
  --     },

  --     -- Note: Hydra mode temporarily disabled due to compatibility issues
  --   },
  --   config = function()
  --     local status_ok, nn = pcall(require, 'notebook-navigator')
  --     if not status_ok then
  --       vim.notify('NotebookNavigator not available', vim.log.levels.WARN)
  --       return
  --     end

  --     nn.setup {
  --       activate_hydra_keys = nil, -- Disable hydra for now to fix the error
  --       syntax_highlight = false, -- Using mini.hipatterns instead
  --     }
  --   end,
  -- },

  -- LuaRocks support for image.nvim dependencies
  {
    'vhyrro/luarocks.nvim',
    priority = 1000,
    config = true,
    opts = {
      rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua' },
    },
  },

  -- Cell highlighting with mini.hipatterns
  -- {
  --   'echasnovski/mini.hipatterns',
  --   event = 'VeryLazy',
  --   dependencies = { 'GCBallesteros/NotebookNavigator.nvim' },
  --   config = function()
  --     local nn = require 'notebook-navigator'
  --     require('mini.hipatterns').setup {
  --       highlighters = {
  --         cells = nn.minihipatterns_spec,
  --       },
  --     }
  --   end,
  -- },
}
