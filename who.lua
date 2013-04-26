
-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}

tags[1] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, 1, awful.layout.suit.tile)
tags[2] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, 2, awful.layout.suit.tile)

awful.layout.set(awful.layout.suit.tile.bottom, tags[2][2])
awful.tag.setnmaster(2, tags[2][2])
awful.tag.setmwfact(0.85, tags[2][2])

customtags = true


-- {{{ Key bindings
globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ modkey,           }, "F12", function () awful.util.spawn(terminal .. " -e bash -c 'cd /home/gclement/src/tetrane/reven ; bash'") end),
   awful.key({ modkey,           }, "F11", function () awful.util.spawn(terminal .. " -e bash -c 'cd /tmp/builds/reven/release/ ; bash'") end),
   awful.key({ modkey,           }, "F10", function () awful.util.spawn(terminal .. " -e bash -c 'cd /tmp/builds/dedal/release/ ; bash'") end),
   awful.key({ "Control", "Mod1" }, "l", function () awful.util.spawn("plasma-overlay") end)
)

rules = {
   { rule = { instance = "emacs" },
     properties = { tag = tags[1][1] } },
   { rule = { instance = "emacs_right" },
     properties = { tag = tags[2][1] } },
   { rule = { class = "URxvt" },
     except = { name = "reven" },
     callback = awful.client.setslave ,
     properties = { border_width = 0 },
   },
   { rule = { class = "URxvt",  name = "reven" },
     callback = function(c)
                   cur = awful.client.getmaster(2)
                   awful.client.setmaster(c)
                   awful.client.setmaster(cur)
                end,
     properties = { border_width = 0 },
   },
   { rule = { class = "Xdot" },
     callback =  function(c)
                   cur = awful.client.getmaster(2)
                   awful.client.setmaster(c)
                   awful.client.setmaster(cur)
                end },
}
