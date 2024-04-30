return {
  {
    "rmagatti/auto-session",
    opts = {
      auto_session_suppress_dirs = { "/", "~/", "~/Desktop", "~/Downloads" },
      bypass_session_save_file_types = { "dashboard" },
      log_level = "error",
      pre_save_cmds = { "NvimTreeClose" },
    },
  },
}
