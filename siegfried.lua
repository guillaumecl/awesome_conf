
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
   -- Each screen has its own tag table.
   tags[s] = awful.tag({  "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒", "➓" }, s, layouts[1])
end
-- }}}
