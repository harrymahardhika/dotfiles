local M = {}

--- Substitute text in a 1-indexed, 1-based visual region using the provided conversion function.
--- @param start_row number 1-indexed start row
--- @param start_col number 1-indexed start column
--- @param end_row number 1-indexed end row
--- @param end_col number 1-indexed end column
--- @param apply_fn function conversion function (e.g. textcase.api.*.apply)
function M.do_substitution(start_row, start_col, end_row, end_col, apply_fn)
  local buf = 0

  -- Convert 1-indexed positions to 0-indexed positions for Neovim's buffer API.
  -- start_row, start_col, end_row are 0-indexed by subtracting 1.
  -- end_col is exclusive in nvim_buf_get_text, which perfectly matches the 1-indexed inclusive value.
  local s_row = start_row - 1
  local s_col = start_col - 1
  local e_row = end_row - 1
  local e_col = end_col

  local line_count = vim.api.nvim_buf_line_count(buf)
  if s_row < 0 or s_row >= line_count or e_row < 0 or e_row >= line_count then
    return
  end

  local s_line_len = string.len(vim.api.nvim_buf_get_lines(buf, s_row, s_row + 1, false)[1] or "")
  local e_line_len = string.len(vim.api.nvim_buf_get_lines(buf, e_row, e_row + 1, false)[1] or "")

  s_col = math.max(0, math.min(s_col, s_line_len))
  e_col = math.max(0, math.min(e_col, e_line_len))

  -- Fetch the selected text from the buffer
  local lines = vim.api.nvim_buf_get_text(buf, s_row, s_col, e_row, e_col, {})
  local text = table.concat(lines, "\n")

  -- Apply the textcase conversion
  local converted = apply_fn(text)
  if not converted or converted == text then
    return
  end

  -- Split the converted text back into lines
  local new_lines = vim.split(converted, "\n", { plain = true })

  -- Update the buffer with the converted lines
  vim.api.nvim_buf_set_text(buf, s_row, s_col, e_row, e_col, new_lines)
end

return M
