return {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
        { "<leader>Sl", function() require("persistence").load() end, desc = "Restore Session (cwd)" },
        { "<leader>Ss", function() require("persistence").select() end, desc = "Select Session" },
        { "<leader>Sd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
}
