local function setup()
  local keymap = require("utils").keymap

  vim.cmd [[command! BreakpointToggle lua require('dap').toggle_breakpoint()]]
  vim.cmd [[command! Debug lua require('dap').continue()]]
  vim.cmd [[command! DapREPL lua require('dap').repl.open()]]

  local opts = { noremap = true, silent = true }
  keymap("n", "<leader>db", function() require("dap").toggle_breakpoint() end, opts)
  keymap("n", "<leader>dc", function() require("dap").continue() end, opts)
  keymap("n", "<leader>di", function() require("dap").step_into() end, opts)
  keymap("n", "<leader>do", function() require("dap").step_over() end, opts)
  keymap("n", "<leader>dO", function() require("dap").step_out() end, opts)
  keymap("n", "<leader>dr", function() require("dap").repl.toggle() end, opts)
  keymap("n", "<leader>dl", function() require("dap").run_last() end, opts)
  keymap("n", "<leader>du", function() require("dapui").toggle() end, opts)
  keymap("n", "<leader>dt", function() require("dap").terminate() end, opts)
end

local function config()
  -- https://alpha2phi.medium.com/neovim-lsp-and-dap-using-lua-3fb24610ac9f
  local dap = require "dap"
  local dapui = require "dapui"

  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
      host = function()
        local value = vim.fn.input "Host [127.0.0.1]: "
        if value ~= "" then return value end
        return "127.0.0.1"
      end,
      port = function()
        local val = tonumber(vim.fn.input "Port: ")
        assert(val, "Please provide a port number")
        return val
      end,
    },
  }

  dap.adapters.nlua =
  function(callback, config) callback { type = "server", host = config.host, port = config.port } end
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

local function configui()
  local dapui = require "dapui"
  dapui.setup {
    expand_lines = true,
    icons = { expanded = "", collapsed = "", circular = "" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    floating = {
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    layouts = {
      {
        elements = {
          -- Elements can be strings or table with id and size keys.
          { id = "scopes", size = 0.25 },
          "breakpoints",
        },
        size = 40, -- 40 columns
        position = "right",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 0.25, -- 25% of total lines
        position = "bottom",
      },
    },
  }
end

return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    init = setup,
    config = config,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = configui,
  },
}
