-- Setup ts_context_commentstring first
local status_ok_ts, ts_context = pcall(require, "ts_context_commentstring")
if status_ok_ts then
  ts_context.setup {
    enable_autocmd = false,
  }
end

local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

comment.setup {
  pre_hook = status_ok_ts and require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook() or nil,
}
