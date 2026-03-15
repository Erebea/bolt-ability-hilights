-- rgb colours of ability and deability outlines
local abilityr = 90
local abilityg = 150
local abilityb = 25
local deabilityr = 204
local deabilityg = 0
local deabilityb = 0

-- converts a number in the range 0-1 to an integer in the range 0-255
local function roundcol (c)
  return math.floor((c * 255.0) + 0.5)
end

-- value multiplier that each letter represents that can appear in ability text
local multipliers = { h = 3600, k = 1000, m = 60 }

-- handlers for every valid character in ability text
local emptyhandler = function () end
local handlers = {
  r = emptyhandler, -- 'r' appears only in 'hr', so we handle 'h' as a multiplier (3600) and ignore 'r's
  ['%'] = emptyhandler,
  ['('] = function (details)
    -- note: '(' and ')' will both lead to this handler, because we don't read enough pixels to
    -- differentiate the two in some fonts, and we also don't need to.
    if details.parens == nil then details.parens = 0 end
  end,
}
for k, v in pairs(multipliers) do
  handlers[k] = function (details)
    if details.parens ~= nil then
      details.parens = details.parens * v
    elseif details.number ~= nil then
      details.number = details.number * v
    end
  end
end
for i = 0, 9 do
  handlers[i] = function (details)
    if details.parens ~= nil then
      details.parens = i + (details.parens * 10)
    elseif details.number ~= nil then
      details.number = i + (details.number * 10)
    else
      details.number = i
    end
  end
end


return {
  -- tries to parse the details of a ability on the screen.
  --
  -- parameters:
  -- `this`: the object returned by require() when importing this module (use the ':' operator)
  -- `event`: the render2d event possibly containing a ability
  -- `startindex`: the index of the image immediately after the image that's suspected of being a
  -- ability, or 1 if the suspected image was seen in a previous event (i.e. onrendericon)
  -- pxleft, pxtop: the top-left corner that the suspected image was drawn at (given by vertextargetxy)
  --
  -- returns up to 4 values:
  -- 1. true if this is a ability, false otherwise. if false, all following values are nil.
  -- 2. the number appearing on the ability, if any. this function will multiply the returned value by
  -- 60 for 'm', 3600 for 'hr', or 1000 for 'k' if any of those appear in the text. if no text appears
  -- at all, this will be nil.
  -- 3. the number appearing in parentheses on the ability, if any. if there are no parentheses, this
  -- wil be nil.
  -- 4. `true` if this is a ability (green), `false` if this is a deability (red).
  --
  -- example.png, in this repo, shows a ability that would return: true, 27, 1, true
  tryreadabilitydetails = function (this, event, startindex, pxleft, pxtop)
    local vertexcount = event:vertexcount()
    local verticesperimage = event:verticesperimage()
    local details = {} -- details.number and details.parens both start as nil

    -- font characters are always double-rendered (black drop-shadow followed by same character in the
    -- intended colour), so we always want to skip reading every second image: step = verticesperimage * 2
    for i = startindex, vertexcount, verticesperimage * 2 do
      -- check if this is a solid-colour rectangle instead of an image
      local u, v = event:vertexuv(i)
      if u == nil or v == nil then
        -- check if this can be identified as a ability outline. if so, there are no more details to
        -- read past that, so just find out if it's a red or green outline and then return true.
        -- on the other hand, if it's not an outline, this wasn't a ability/deability at all, so return false.
        local x, y = event:vertexxy(i + 2)
        if x == pxleft and y == pxtop then
          local fr, fg, fb = event:vertexcolour(i)
          local rfr, rfg, rfb = roundcol(fr), roundcol(fg), roundcol(fb)
          if rfr == abilityr and rfg == abilityg and rfb == abilityb then
            return true, details.number, details.parens, true
          elseif rfr == deabilityr and rfg == deabilityg and rfb == deabilityb then
            return true, details.number, details.parens, false
          end
        end
        return false
      end

      -- try to find this character
      local char = this:lookupchar(event, event:vertexatlasdetails(i))
      local handler = handlers[char]
      if not handler then return false end
      handler(details)
    end
    return false
  end,

  -- given some atlas coordinates and a render2d event, looks up a character in the ability text font.
  -- returns a number 0-9, or a string containing exactly 1 character, or nil.
  -- the '(' or ')' characters will both always return '('.
  -- ax,ay,aw,ah are the first four values returned by event:vertexatlasdetails
  lookupchar = function (this, event, ax, ay, aw, ah)
    local chars, row1--, row2

    if ah <= this.smallcharsrow1 then
      -- safety check on image size
      return nil
    elseif ah <= this.charsrow1 then
      --chars = this.smallchars
      --row1 = this.smallcharsrow1
      --row2 = this.smallcharsrow2
    else
      chars = this.cdchars
      row1 = this.charsrow1
      --row2 = this.charsrow2
    end

    local char = chars[event:texturedata(ax, ay + row1, aw * 13)]
    --if type(char) == "table" then
    --  char = char[event:texturedata(ax, ay + row2, aw * 4)]
    --end
    return char
  end,


  -- lookup table of the 7th row (1-indexed, so y+6) of pixels in each character that can appear on a ability.
  -- four different fonts can appear depending on settings and the text being rendered: small, medium, medium2, and large.
  -- small2 is used when the size is set to "small" and there's a parentheses number on the ability.
  -- medium2 is used when the size is set to "medium" or "large", but there's too much text to fit using the normal font.
  -- medium3 is used when the size is set to "medium" or "large" and there's a parentheses number on the ability.
  -- note: '(' and ')' will both return '(' from this table, since we don't read enough pixels to tell the difference
  -- between the two in some fonts, and we don't need to differentiate the two in order to read abilities correctly.
  cdchars = {
    ['\x00\x00\x00\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\x00\x00\x00\xff\x00\x00\x00\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\x00\x00\x00\xff'] = 0, -- @0
    ['\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x00\x00\x00\xff\x00\x00\x00\xff\x00\x00\x00\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\x00\x00\x00\xff\x00\x00\x00\x00\x00\x00\x00\x00'] = 1, -- @1
    ['\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\xff\x03\x03\x03\xff\xfb\xfb\xfb\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\x44\x44\xff\x00\x00\x00\xff\x00\x00\x00\x77'] = 2, -- @2
    ['\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xaf\x00\x00\x00\xff\x35\x35\x35\xff\x45\x45\x45\xff\x61\x61\x61\xff\xbc\xbc\xbc\xff\xff\xff\xff\xff\xff\xff\xff\xff\xdd\xdd\xdd\xff\x03\x03\x03\xff\x00\x00\x00\xff\x00\x00\x00\x3a'] = 3, -- @3
    ['\x00\x00\x00\x00\x00\x00\x00\x24\x00\x00\x00\xff\x00\x00\x00\xff\xc5\xc5\xc5\xff\xff\xff\xff\xff\xe0\xe0\xe0\xff\x00\x00\x00\xff\xe1\xe1\xe1\xff\xff\xff\xff\xff\xff\xff\xff\xff\x49\x49\x49\xff\x00\x00\x00\xff\x00\x00\x00\x6d'] = 4, -- @4
    ['\x00\x00\x00\xd6\x00\x00\x00\xff\xd2\xd2\xd2\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xdc\xdc\xdc\xff\x3b\x3b\x3b\xff\x00\x00\x00\xff\x00\x00\x00\xe0\x00\x00\x00\x00'] = 5, -- @5
    ['\x00\x00\x00\xff\x00\x00\x00\xff\xfe\xfe\xfe\xff\xff\xff\xff\xff\xfe\xfe\xfe\xff\x4c\x4c\x4c\xff\xf7\xf7\xf7\xff\xff\xff\xff\xff\xff\xff\xff\xff\xeb\xeb\xeb\xff\x50\x50\x50\xff\x00\x00\x00\xff\x00\x00\x00\xff\x00\x00\x00\x00'] = 6, -- @6
    ['\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x00\x00\x00\xff\xd4\xd4\xd4\xff\xff\xff\xff\xff\xff\xff\xff\xff\x67\x67\x67\xff\x00\x00\x00\xff\x00\x00\x00\x80\x00\x00\x00\x00'] = 7, -- @7
    ['\x00\x00\x00\x2b\x00\x00\x00\xff\x00\x00\x00\xff\xdf\xdf\xdf\xff\xff\xff\xff\xff\xff\xff\xff\xff\xee\xee\xee\xff\xe7\xe7\xe7\xff\xff\xff\xff\xff\xff\xff\xff\xff\xc5\xc5\xc5\xff\x00\x00\x00\xff\x00\x00\x00\xff\x00\x00\x00\x28'] = 8, -- @8
    ['\x00\x00\x00\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\x00\x00\x00\xff\x00\x00\x00\xff\x19\x19\x19\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\x00\x00\x00\xff'] = 9, -- @9
    ['\x00\x00\x00\x9e\x00\x00\x00\xff\x6a\x6a\x6a\xff\xff\xff\xff\xff\xff\xff\xff\xff\x67\x67\x67\xff\x00\x00\x00\xff\x00\x00\x00\x9e'] = ':', -- @:
  },
  charsrow1 = 15,

}