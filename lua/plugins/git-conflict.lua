-- plugins/git-conflict.lua
-- Modern inline merge conflict resolution (like VS Code/Cursor)
--
-- MERGE CONFLICT WORKFLOW:
-- 1. When you hit a merge conflict, open the file - you'll see inline markers:
--    <<<<<<< CURRENT (your changes)
--    your code
--    =======
--    their code
--    >>>>>>> INCOMING (their changes)
--
-- 2. Resolve conflicts with simple keybinds:
--    <leader>xc - Choose CURRENT (keep your changes)
--    <leader>xi - Choose INCOMING (accept their changes)
--    <leader>xb - Choose BOTH (keep both versions)
--    <leader>x0 - Choose NONE (delete both, start fresh)
--
-- 3. Navigate between conflicts:
--    ]x - Next conflict
--    [x - Previous conflict
--
-- 4. See all conflicts:
--    <leader>xl - List all conflicts in quickfix window

return {
  'akinsho/git-conflict.nvim',
  version = '*',
  config = function()
    require('git-conflict').setup {
      default_mappings = false, -- disable default keybinds, we'll set our own
      disable_diagnostics = false, -- set to false to avoid deprecation warning
      list_opener = 'copen', -- open conflicts in quickfix window
      highlights = {
        current = 'DiffAdd',
        incoming = 'DiffChange',
        ancestor = 'DiffText',
      },
    }

    -- Keybindings that match the UI labels (CURRENT/INCOMING)
    vim.keymap.set('n', '<leader>xc', '<Plug>(git-conflict-ours)', { desc = 'Choose CURRENT (our changes)' })
    vim.keymap.set('n', '<leader>xi', '<Plug>(git-conflict-theirs)', { desc = 'Choose INCOMING (their changes)' })
    vim.keymap.set('n', '<leader>xb', '<Plug>(git-conflict-both)', { desc = 'Choose BOTH' })
    vim.keymap.set('n', '<leader>x0', '<Plug>(git-conflict-none)', { desc = 'Choose NONE' })
    vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)', { desc = 'Next conflict' })
    vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)', { desc = 'Previous conflict' })
    vim.keymap.set('n', '<leader>xl', '<cmd>GitConflictListQf<cr>', { desc = 'List all conflicts' })
  end,
}
