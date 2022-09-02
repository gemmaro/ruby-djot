local make_match, unpack_match

if jit or not string.pack then
  -- for luajit or lua 5.1, we don't have string.pack/unpack, so we use arrays.
  -- This is faster than using ffi to pack things in C structs.

  make_match = function(startpos, endpos, annotation)
    return {startpos, endpos, annotation}
  end

  unpack_match = unpack

else
  -- for standard lua >= 5.2, we use string.pack/unpack which gives a
  -- more memory-efficient representation than arrays.

  make_match = function(startpos, endpos, annotation)
    return string.pack("=I4I4z", startpos, endpos, annotation)
  end

  unpack_match = function(match)
    local startpos, endpos, annotation = string.unpack("=I4I4z", match)
    return startpos, endpos, annotation
  end
end

local get_length = function(match)
  local startpos, endpos = unpack_match(match)
  return 1 + (endpos - startpos)
end

local format_match = function(match)
  local startpos, endpos, annotation = unpack_match(match)
  return string.format("%-s %d-%d\n", annotation, startpos, endpos)
end

local function matches_pattern(match, patt)
  if match then
    local _, _, annot = unpack_match(match)
    return string.find(annot, patt)
  end
end

return {
  make_match = make_match,
  unpack_match = unpack_match,
  get_length = get_length,
  format_match = format_match,
  matches_pattern = matches_pattern
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
