return {
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to Left Panel" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to Lower Panel" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to Upper Panel" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to Right Panel" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to Previous Panel" },
    },
  },
}
