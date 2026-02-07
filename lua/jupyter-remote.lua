local M = {}

local config_path = vim.fn.stdpath('config') .. '/jupyter_connections.json'

--- Read jupyter_connections.json and return parsed table
local function read_connections()
  local f = io.open(config_path, 'r')
  if not f then
    vim.notify('jupyter_connections.json not found at ' .. config_path, vim.log.levels.ERROR)
    return nil
  end
  local content = f:read('*a')
  f:close()
  local ok, data = pcall(vim.json.decode, content)
  if not ok then
    vim.notify('Failed to parse jupyter_connections.json: ' .. tostring(data), vim.log.levels.ERROR)
    return nil
  end
  return data
end

--- Write connections table back to jupyter_connections.json
local function write_connections(data)
  local json = vim.json.encode(data)
  local f = io.open(config_path, 'w')
  if not f then
    vim.notify('Cannot write to ' .. config_path, vim.log.levels.ERROR)
    return false
  end
  f:write(json)
  f:close()
  return true
end

--- Get sorted list of server names
local function server_names(connections)
  local names = {}
  for name in pairs(connections) do
    names[#names + 1] = name
  end
  table.sort(names)
  return names
end

--- Build MoltenInit URL from a connection entry
local function build_url(entry)
  local url = entry.url:gsub('/+$', '')
  url = url .. '/?token=' .. entry.token
  if entry.kernel_name then
    url = url .. '&kernel_name=' .. entry.kernel_name
  end
  return url
end

--- Connect to a JupyterHub server via MoltenInit
function M.connect()
  local connections = read_connections()
  if not connections then return end

  local names = server_names(connections)
  if #names == 0 then
    vim.notify('No servers in jupyter_connections.json', vim.log.levels.WARN)
    return
  end

  local function init_kernel(name, entry)
    local url = build_url(entry)
    vim.notify('Connecting to ' .. name .. '...', vim.log.levels.INFO)
    vim.cmd('MoltenInit ' .. url)
  end

  if #names == 1 then
    init_kernel(names[1], connections[names[1]])
    return
  end

  vim.ui.select(names, { prompt = 'Select JupyterHub server:' }, function(choice)
    if not choice then return end
    init_kernel(choice, connections[choice])
  end)
end

--- Interactively update a server's token
function M.update_token()
  local connections = read_connections()
  if not connections then return end

  local names = server_names(connections)
  if #names == 0 then
    vim.notify('No servers in jupyter_connections.json', vim.log.levels.WARN)
    return
  end

  vim.ui.select(names, { prompt = 'Update token for:' }, function(choice)
    if not choice then return end
    vim.ui.input({ prompt = 'New token for ' .. choice .. ': ' }, function(token)
      if not token or token == '' then return end
      connections[choice].token = token
      if write_connections(connections) then
        vim.notify('Token updated for ' .. choice, vim.log.levels.INFO)
      end
    end)
  end)
end

--- Show connection status for all configured servers
function M.status()
  local connections = read_connections()
  if not connections then return end

  local names = server_names(connections)
  if #names == 0 then
    vim.notify('No servers in jupyter_connections.json', vim.log.levels.WARN)
    return
  end

  local lines = { 'Jupyter Connections:' }
  for _, name in ipairs(names) do
    local entry = connections[name]
    local token_preview = entry.token:sub(1, 8) .. '...'
    local kernel = entry.kernel_name or 'default'
    lines[#lines + 1] = string.format('  %s: kernel=%s token=%s', name, kernel, token_preview)
    lines[#lines + 1] = string.format('    %s', entry.url)
  end
  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end

return M
