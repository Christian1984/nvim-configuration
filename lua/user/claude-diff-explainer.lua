require("claude-diff-explainer").setup({
  language = "Deutsch",
  model = nil, -- e.g. "sonnet" or "haiku"; nil = Claude Code default
  -- the dialog lives next to the ticket's PRD and issues, lowercase slug like those folders
  dialog = function(root, ticket)
    return root .. "/.scratch/" .. ticket:lower() .. "/code-explain.md"
  end,
  labels = { question = "**Frage:**", pending = "_Claude antwortet…_", prompt = "Frage an Claude: " },
})

vim.keymap.set("x", "<leader>e", ":ClaudeDiffExplain<CR>", { silent = true, desc = "Explain selection with Claude" })
