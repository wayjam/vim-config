local function setup()
  local map = require("utils").map

  vim.cmd [[command! BreakpointToggle lua require('dap').toggle_breakpoint()]]
  vim.cmd [[command! Debug lua require('dap').continue()]]
  vim.cmd [[command! DapREPL lua require('dap').repl.open()]]

  local opts = { silent = true }
  map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
  map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
  map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
  map("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
  map("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
  map("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
  map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
  map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
  map("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)
end

local function config()
  -- https://alpha2phi.medium.com/neovim-lsp-and-dap-using-lua-3fb24610ac9f
  local dap = require "dap"

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
      host = function()
        local value = vim.fn.input "Host [127.0.0.1]: "
        if value ~= "" then
          return value
        end
        return "127.0.0.1"
      end,
      port = function()
        local val = tonumber(vim.fn.input "Port: ")
        assert(val, "Please provide a port number")
        return val
      end,
    },
  }

  dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host, port = config.port }
  end

  dap.adapters.go = function(callback, config)
    local handle
    local pid_or_err
    local port = 38697
    handle, pid_or_err = vim.loop.spawn(
      "dlv",
      { args = { "dap", "-l", "127.0.0.1:" .. port }, detached = true },
      function(code)
        handle:close()
        print("Delve exited with exit code: " .. code)
      end
    )
    -- Wait 100ms for delve to start
    vim.defer_fn(function()
      dap.repl.open()
      callback { type = "server", host = "127.0.0.1", port = port }
    end, 100)
  end
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  dap.configurations.go = {
    { type = "go", name = "Debug", request = "launch", program = "${file}" },
    {
      type = "go",
      name = "Debug test",
      request = "launch",
      mode = "test", -- Mode is important
      program = "${file}",
    },
  }
end

return { setup = setup, config = config }
