--- Patch molten-nvim's jupyter_server_api.py to fix JupyterHub connections.
--- Idempotent: skips if already patched (checks for `parsed_url.path`).
local function patch_molten_server_api()
  local api_path = vim.fn.stdpath('data') .. '/lazy/molten-nvim/rplugin/python3/molten/jupyter_server_api.py'
  local f = io.open(api_path, 'r')
  if not f then
    vim.notify('molten jupyter_server_api.py not found — skipping patch', vim.log.levels.WARN)
    return
  end
  local content = f:read('*a')
  f:close()

  -- Already patched?
  if content:find('parsed_url%.path', 1, false) then
    vim.notify('molten jupyter_server_api.py already patched', vim.log.levels.INFO)
    return
  end

  -- Patch 1: Preserve URL path in base_url
  content = content:gsub(
    'self%._base_url = f"{parsed_url%.scheme}://{parsed_url%.netloc}"',
    'self._base_url = f"{parsed_url.scheme}://{parsed_url.netloc}{parsed_url.path}".rstrip("/")'
  )

  -- Patch 3: Extract kernel_name from query params (insert after base_url line)
  content = content:gsub(
    '(self%._base_url = f"{parsed_url%.scheme}://{parsed_url%.netloc}{parsed_url%.path}"%.rstrip%("/"%))',
    '%1\n        self._kernel_name = parse_qs(parsed_url.query).get("kernel_name", [None])[0]'
  )

  -- Ensure parse_qs is imported
  if not content:find('from urllib%.parse import.*parse_qs') then
    content = content:gsub(
      '(from urllib%.parse import )',
      '%1parse_qs, '
    )
    -- If the import line doesn't use `from urllib.parse import`, try adding standalone
    if not content:find('parse_qs') then
      content = content:gsub(
        '(from urllib%.parse import [^\n]+)',
        '%1\nfrom urllib.parse import parse_qs'
      )
    end
  end

  -- Patch 2: Fix WebSocket scheme + netloc
  content = content:gsub(
    'self%._socket = websocket%.create_connection%(f"ws://{parsed_url%.hostname}:{parsed_url%.port}"\n(%s+)f"/api/kernels/{self%._kernel_info%[\'id\'%]}/channels"',
    '_ws_scheme = "wss" if parsed_url.scheme == "https" else "ws"\n        self._socket = websocket.create_connection(f"{_ws_scheme}://{parsed_url.netloc}"\n%1f"{parsed_url.path.rstrip(\'/\')}/api/kernels/{self._kernel_info[\'id\']}/channels"'
  )

  -- Patch 3b: Pass kernel name in start_kernel
  content = content:gsub(
    '(response = self%.requests%.post%(url,\n%s+headers=self%._headers%))',
    'body = {"name": self._kernel_name} if self._kernel_name else None\n        response = self.requests.post(url,\n                                 headers=self._headers,\n                                 json=body)'
  )

  local out = io.open(api_path, 'w')
  if not out then
    vim.notify('Cannot write patched jupyter_server_api.py', vim.log.levels.ERROR)
    return
  end
  out:write(content)
  out:close()
  vim.notify('Patched molten jupyter_server_api.py for JupyterHub support', vim.log.levels.INFO)
end

return {
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

  -- Molten.nvim - Jupyter kernel execution with inline output
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    build = function()
      vim.cmd(':UpdateRemotePlugins')
      patch_molten_server_api()
    end,
    init = function()
      vim.g.molten_image_provider = 'none'
      vim.g.molten_auto_open_output = true
      vim.g.molten_open_cmd = 'open'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_text_max_lines = 12
      vim.g.molten_wrap_output = true
      vim.g.molten_enter_output_behavior = 'open_and_enter'
      vim.g.molten_output_show_exec_time = true
      vim.g.molten_save_path = vim.fn.stdpath 'data' .. '/molten'
    end,
    config = function()
      local remote = require('jupyter-remote')

      -- Kernel management
      vim.keymap.set('n', '<leader>mi', ':MoltenInit<CR>', { desc = 'Molten: Init kernel' })
      vim.keymap.set('n', '<leader>mI', remote.connect, { desc = 'Molten: Connect JupyterHub' })
      vim.keymap.set('n', '<leader>mR', ':MoltenRestart!<CR>', { desc = 'Molten: Restart kernel' })
      vim.keymap.set('n', '<leader>mx', ':MoltenInterrupt<CR>', { desc = 'Molten: Interrupt' })
      vim.keymap.set('n', '<leader>mD', ':MoltenDeinit<CR>', { desc = 'Molten: Disconnect' })
      vim.keymap.set('n', '<leader>mf', ':MoltenInfo<CR>', { desc = 'Molten: Info' })
      vim.keymap.set('n', '<leader>ms', ':MoltenShowOutput<CR>', { desc = 'Molten: Show output' })
      vim.keymap.set('n', '<leader>mh', ':MoltenHideOutput<CR>', { desc = 'Molten: Hide output' })
      vim.keymap.set('n', '<leader>me', ':noautocmd MoltenEnterOutput<CR>', { desc = 'Molten: Enter output' })

      -- Yank output to clipboard
      vim.keymap.set('n', '<leader>my', function()
        local start_win = vim.api.nvim_get_current_win()
        -- MoltenEnterOutput is sync — opens float and moves cursor into it
        vim.cmd('noautocmd MoltenEnterOutput')
        local out_win = vim.api.nvim_get_current_win()
        if out_win == start_win then
          vim.notify('No molten output to copy', vim.log.levels.WARN)
          return
        end
        local buf = vim.api.nvim_win_get_buf(out_win)
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        vim.fn.setreg('+', table.concat(lines, '\n'))
        vim.api.nvim_set_current_win(start_win)
        vim.notify('Output copied to clipboard', vim.log.levels.INFO)
      end, { desc = 'Molten: Yank output' })

      -- Remote connection management
      vim.keymap.set('n', '<leader>mt', remote.update_token, { desc = 'Molten: Update token' })
      vim.keymap.set('n', '<leader>mS', remote.status, { desc = 'Molten: Connection status' })
    end,
  },

  -- NotebookNavigator - cell detection, navigation, and execution for # %% files
  {
    'GCBallesteros/NotebookNavigator.nvim',
    dependencies = {
      'echasnovski/mini.comment',
    },
    ft = { 'python' },
    config = function()
      local nn = require('notebook-navigator')
      nn.setup({
        repl_provider = 'molten',
      })

      -- Cell execution
      vim.keymap.set('n', '<leader>mc', function() nn.run_cell() end, { desc = 'Molten: Run cell' })
      vim.keymap.set('n', '<leader>mr', function() nn.run_and_move() end, { desc = 'Molten: Run cell & move' })

      -- Cell navigation
      vim.keymap.set('n', ']c', function() nn.move_cell('d') end, { desc = 'Next cell' })
      vim.keymap.set('n', '[c', function() nn.move_cell('u') end, { desc = 'Previous cell' })
    end,
  },
}
