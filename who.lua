-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
   -- Each screen has its own tag table.
   tags[s] = awful.tag({ "➊", "➋", "➌", "➍"}, s, awful.layout.suit.tile)
   --
end

customtags = true


-- {{{ Key bindings
globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ modkey,           }, "F12", function () awful.util.spawn(terminal .. " -e bash -c 'cd /home/gclement/src/tetrane/reven ; bash'") end),
   awful.key({ modkey,           }, "F11", function () awful.util.spawn(terminal .. " -e bash -c 'cd /tmp/builds/reven/debug/ ; bash'") end),
   awful.key({ modkey,           }, "F10", function () awful.util.spawn(terminal .. " -e bash -c 'cd /tmp/builds/dedal/debug/ ; bash'") end)
)

rules = {
   { rule = { instance = "emacs" },
     properties = { tag = tags[1][1] } },
   { rule = { instance = "emacs_right" },
     properties = { tag = tags[2][1] } }
}
