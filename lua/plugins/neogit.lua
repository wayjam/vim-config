local function neogit_open(opts)
  return function() require("neogit").open(opts) end
end

return {
  "NeogitOrg/neogit",
  enabled = vim.fn.executable "git" == 1,
  cmd = {
    "Neogit",
    "NeogitResetState",
    "NeogitLog",
    "NeogitCommit",
    "G",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "esmuellert/codediff.nvim",
  },
  keys = {
    {
      "<leader>Gd",
      "<cmd>CodeDiff<CR>",
      desc = "Git diff",
    },
    {
      "<leader>Gs",
      neogit_open(),
      desc = "Git status",
    },
    {
      "<leader>GC",
      neogit_open { "commit" },
      desc = "Git commit",
    },
    {
      "<leader>Gb",
      "<cmd>Gitsigns blame<CR>",
      desc = "Git blame",
    },
    {
      "<leader>Gp",
      neogit_open { "push" },
      desc = "Git push",
    },
    {
      "<leader>Gl",
      neogit_open { "log" },
      desc = "Git log",
    },
    {
      "<leader>GF",
      "<cmd>diffget //2<CR>",
      desc = "Git Use left content",
    },
    {
      "<leader>GJ",
      "<cmd>diffget //3<CR>",
      desc = "Git use right content",
    },
    {
      "<leader>Gi",
      neogit_open(),
      desc = "Git interactive stage",
    },
  },
  opts = {
    kind = "tab",
    diff_viewer = "codediff",
    integrations = {
      codediff = true,
      diffview = false,
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- :G  — fugitive-style shortcut forwarded to Neogit.
    --   :G           -> Neogit status (default)
    --   :G log        -> NeogitLog
    --   :G commit           -> commit popup (create)
    --   :G commit --amend   -> NeogitCommit (amend)
    --   :G push       -> push popup
    --   :G pull       -> pull popup
    --   :G fetch      -> fetch popup
    --   :G diff       -> :CodeDiff (skip Neogit diff popup)
    --   :G blame      -> Gitsigns blame
    --   :G reset      -> reset popup
    --   :G stash      -> stash popup
    --   :G branch      -> branch popup
    --   :G merge      -> merge popup
    --   :G rebase     -> rebase popup
    --   :G revert     -> revert popup
    --   :G cherry_pick -> cherry-pick popup
    --   :G tag        -> tag popup
    --   :G remote     -> remote popup
    --   :G worktree   -> worktree popup
    --   :G bisect     -> bisect popup
    --   :G ignore     -> ignore popup
    local popup_for = {
      log = "NeogitLog",
      commit = function() require("neogit").open { "commit" } end,
      diff = "CodeDiff",
      blame = "Gitsigns blame",
    }
    local popup_sub = {
      push = true,
      pull = true,
      fetch = true,
      reset = true,
      stash = true,
      branch = true,
      merge = true,
      rebase = true,
      revert = true,
      cherry_pick = true,
      tag = true,
      remote = true,
      worktree = true,
      bisect = true,
      ignore = true,
    }
    vim.api.nvim_create_user_command("G", function(args)
      local sub = args.fargs[1]
      if not sub or sub == "" then
        require("neogit").open()
        return
      end
      -- :G commit --amend  -> NeogitCommit (amend previous commit)
      if sub == "commit" and vim.tbl_contains(args.fargs, "--amend") then
        vim.cmd("NeogitCommit")
        return
      end
      if popup_sub[sub] then
        require("neogit").open { sub }
        return
      end
      local cmd = popup_for[sub]
      if cmd then
        if type(cmd) == "function" then
          cmd()
        else
          vim.cmd(cmd)
        end
        return
      end
      -- Unknown subcommand: open Neogit status instead of silent shell-out.
      require("neogit").open()
    end, {
      nargs = "*",
      force = true,
      complete = function(_, line)
        local subs = vim.tbl_keys(popup_sub)
        vim.list_extend(subs, vim.tbl_keys(popup_for))
        table.sort(subs)
        local before = line:match "^%s*G%s+(.*)$"
        if before then return {} end
        return vim.tbl_filter(function(s) return s:match("^" .. vim.pesc(before or "")) end, subs)
      end,
    })
  end,
}
