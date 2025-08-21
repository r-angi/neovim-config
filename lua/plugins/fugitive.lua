-- plugins/fugitive.lua
-- Git integration for Neovim using vim-fugitive

--[[
MERGE CONFLICT RESOLUTION WORKFLOW:

1. When you encounter merge conflicts:
   - Open the conflicted file in Neovim
   - Use <leader>gd to open 3-way diff view

2. Understanding the 3-way diff layout:
   - LEFT pane:   //2 (HEAD - your current branch)
   - MIDDLE pane: Working copy (where you resolve conflicts)
   - RIGHT pane:  //3 (incoming branch - what you're merging)

3. Navigate between conflicts:
   - ]c - Jump to next conflict
   - [c - Jump to previous conflict

4. Resolve conflicts (choose which version to keep):
   - <leader>gh - Get from HEAD (left pane, your current branch)
   - <leader>gt - Get from target/incoming branch (right pane)
   - Or manually edit the middle pane

5. After resolving:
   - <leader>gw - Stage the resolved file (Gwrite)
   - Repeat for all conflicted files
   - <leader>gc - Commit the merge

6. Alternative workflow:
   - <leader>gm - Use Git mergetool to cycle through all conflicts

FUGITIVE DIFF COMMANDS EXPLAINED:
- //2 refers to the "second parent" (HEAD/current branch)
- //3 refers to the "third parent" (incoming/merge branch)
- This numbering comes from git's internal representation of merge commits
--]]

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

    -- Merge conflict resolution
    { '<leader>gd', '<cmd>Gvdiffsplit!<cr>', desc = 'Git diff split (3-way)' },
    { '<leader>gh', '<cmd>diffget //2<cr>', desc = 'Get from HEAD (current branch)' },
    { '<leader>gt', '<cmd>diffget //3<cr>', desc = 'Get from target (incoming branch)' },
    { '<leader>gw', '<cmd>Gwrite<cr>', desc = 'Stage resolved file' },
    { '<leader>gm', '<cmd>Git mergetool<cr>', desc = 'Git mergetool' },

    -- Diff navigation (works in diff mode)
    {
      ']c',
      function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          vim.cmd.normal ']c'
        end
      end,
      desc = 'Next conflict/change',
    },
    {
      '[c',
      function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          vim.cmd.normal '[c'
        end
      end,
      desc = 'Previous conflict/change',
    },

    -- Additional useful shortcuts
    { '<leader>gf', '<cmd>Git fetch<cr>', desc = 'Git fetch' },
    { '<leader>gr', '<cmd>Gread<cr>', desc = 'Git checkout current file' },
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
