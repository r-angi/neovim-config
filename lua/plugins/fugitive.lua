-- plugins/fugitive.lua
-- Git integration for Neovim using vim-fugitive
--
-- BASIC GIT WORKFLOW:
-- <leader>gs - Git status (stage/unstage files, commit, etc.)
-- <leader>gc - Git commit
-- <leader>gp - Git push
-- <leader>gP - Git pull
-- <leader>gb - Git blame
-- <leader>gL - Git log
-- <leader>go - Open current file in GitHub
--
-- NOTE: For merge conflict resolution, use git-conflict.nvim (see git-conflict.lua)

return {
  'tpope/vim-fugitive',
  dependencies = {
    'tpope/vim-rhubarb', -- GitHub integration for :GBrowse
  },
  cmd = { 'Git', 'G' },
  keys = {
    -- Basic Git operations
    { '<leader>gs', '<cmd>Git<cr>', desc = 'Git status' },
    { '<leader>gc', '<cmd>Git commit<cr>', desc = 'Git commit' },
    { '<leader>gp', '<cmd>Git push<cr>', desc = 'Git push' },
    { '<leader>gP', '<cmd>Git pull<cr>', desc = 'Git pull' },
    { '<leader>gb', '<cmd>Git blame<cr>', desc = 'Git blame' },
    { '<leader>gL', '<cmd>Git log<cr>', desc = 'Git log' },
    { '<leader>gf', '<cmd>Git fetch<cr>', desc = 'Git fetch' },
    { '<leader>go', '<cmd>GBrowse<cr>', desc = 'Open in GitHub' },
  },

  config = function()
    -- Set up additional autocommands or configurations
    vim.api.nvim_create_autocmd('BufWinEnter', {
      group = vim.api.nvim_create_augroup('fugitive_settings', { clear = true }),
      pattern = '*',
      callback = function()
        if vim.bo.filetype == 'fugitive' then
          -- Set local keymaps for fugitive buffers
          local bufnr = vim.api.nvim_get_current_buf()
          vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = bufnr, desc = 'Close fugitive buffer' })
        end
      end,
    })
  end,
}
