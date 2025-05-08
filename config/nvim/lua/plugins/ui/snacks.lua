local Snacks = require("snacks")

local icons = require("lib.icons")

Snacks.setup({
  bigfile = { enabled = true },
  dashboard = {
    preset = {
      keys = {
        -- stylua: ignore start
        { icon = icons.ui.File,      key = "n", desc = "New File",     action = ":ene | startinsert" },
        { icon = icons.ui.Magnifier, key = "f", desc = "Find File",    action = ":lua Snacks.dashboard.pick('files')" },
        { icon = icons.ui.Text,      key = "/", desc = "Find Text",    action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = icons.ui.Copy,      key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = icons.ui.Sleep,
          key = "L",
          desc = "Lazy",
          action = ":Lazy",
          enabled = package.loaded.lazy ~= nil
        },
        { icon = icons.ui.SignOut, key = "q", desc = "Quit", action = ":qa" },
        -- stylua: ignore end
      },
    },
    sections = {
      -- { section = "header" },
      {
        section = "terminal",
        cmd = "chafa ~/.config/nvim/assets/apple.png --format symbols --symbols vhalf --size 24x24 --align center; sleep .1",
        height = 12,
        padding = 1,
      },
      { title = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), align = "center", padding = 1 },
      { title = "General", padding = 1 },
      { section = "keys", gap = 1, padding = 1 },
      function()
        local in_git = Snacks.git.get_root() ~= nil
        local cmds = {
          { title = "Git", padding = 1 },
          {
            desc = "Browse Repo",
            icon = " ",
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          {
            desc = "Open Issues",
            icon = icons.ui.OpenIssue,
            key = "i",
            action = function()
              vim.fn.jobstart("gh issue list --web", { detach = true })
            end,
          },
          {
            desc = "Open Pull Requests",
            icon = icons.ui.PullRequest,
            key = "p",
            action = function()
              vim.fn.jobstart("gh pr list --web", { detach = true })
            end,
          },
          {
            section = "terminal",
            icon = " ",
            title = "Status\n",
            cmd = "git --no-pager diff --stat -B -M -C",
            height = 8,
            padding = 1,
            ttl = 0,
          },
        }

        return vim.tbl_map(function(cmd)
          return vim.tbl_extend("force", {
            enabled = in_git,
            padding = 1,
          }, cmd)
        end, cmds)
      end,
      { section = "startup" },
    },
  },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  picker = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = {
    enabled = false, -- TODO: turning this off for now due to lag
    animate = {
      duration = { steps = 15, total = 200 },
      easing = "inOutQuad",
    },
  },
  statuscolumn = { enabled = true },
  win = { enabled = true },
  words = { enabled = true },
  zen = {
    show = {
      statusline = false,
      tabline = false,
    },
    toggles = {
      dim = true,
    },
    win = {
      backdrop = {
        blend = 30,
        transparent = true,
      },
      width = 100,
    },
  },
})
