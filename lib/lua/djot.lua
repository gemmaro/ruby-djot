local block = require("djot.block")
local ast = require("djot.ast")
local html = require("djot.html")
local match = require("djot.match")

local format_match = match.format_match

local StringHandle = {}

function StringHandle:new()
  local buffer = {}
  setmetatable(buffer, StringHandle)
  StringHandle.__index = StringHandle
  return buffer
end

function StringHandle:write(s)
  self[#self + 1] = s
end

function StringHandle:flush()
  local result = table.concat(self)
  self = {}
  return result
end

local Parser = block.Parser

function Parser:issue_warnings(handle)
  if self.opts.verbose then
    local warnings = self.warnings
    for i=1,#warnings do
      handle:write(string.format("Warning: %s at byte position %d\n",
                                    warnings[i][2], warnings[i][1]))
    end
  end
end

function Parser:render_matches(handle)
  if not handle then
    handle = StringHandle:new()
  end
  local matches = self:get_matches()
  self:issue_warnings(io.stderr)
  for i=1,#matches do
    handle:write(format_match(matches[i]))
  end
  return handle:flush()
end

function Parser:build_ast()
  self.ast = ast.to_ast(self.subject, self.matches, self.opts)
end

function Parser:render_ast(handle)
  if not handle then
    handle = StringHandle:new()
  end
  if not self.ast then
    self:build_ast()
  end
  self:issue_warnings(io.stderr)
  ast.render(self.ast, handle)
  return handle:flush()
end

function Parser:render_html(handle)
  if not handle then
    handle = StringHandle:new()
  end
  if not self.ast then
    self:build_ast()
  end
  self:issue_warnings(io.stderr)
  local renderer = html.Renderer:new()
  renderer:render(self.ast, handle)
  return handle:flush()
end

return {
  Parser = Parser
}


--[[
Copyright (C) 2022 John MacFarlane

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]
