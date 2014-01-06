
-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}

tags[1] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, 1, awful.layout.suit.tile)
tags[2] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, 2, awful.layout.suit.tile)

awful.layout.set(awful.layout.suit.tile.bottom, tags[2][2])
--awful.tag.setnmaster(2, tags[2][2])
awful.tag.setmwfact(0.85, tags[2][2])
awful.tag.setmwfact(0.85, tags[2][1])

customtags = true


-- {{{ Key bindings
globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ modkey,           }, "F12", function () awful.util.spawn(terminal .. " -cd /home/gclement/src/tetrane/reven") end),
   awful.key({ modkey,           }, "F11", function () awful.util.spawn(terminal .. " -cd /tmp/builds/reven/release") end),
   awful.key({ modkey,           }, "F10", function () awful.util.spawn(terminal .. " -cd /tmp/builds/reven/debug") end),
   awful.key({ "Control", "Mod1" }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),
   -- awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q sset Master 2-") end),
   -- awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q sset Master 2+") end),
   -- awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer -q sset Master toggle") end),
   awful.key({ modkey,           }, "p", function () awful.util.spawn("bash -c 'cd /tmp/builds/reven/release/python/ ; ipython qtconsole --colors=linux --autoindent --ConsoleWidget.font_family=\"Terminus\" --ConsoleWidget.font_size=11'") end),
   awful.key({ modkey,           }, "y", function () run_or_raise("/home/gclement/src/tmpc/build/tmpc", { instance = "tmpc" } ) end),
   awful.key({ modkey,           }, "c", function () awful.util.spawn("/home/gclement/src/tmpc/build/tmpc --current") end),
   awful.key({ modkey,           }, "q", function () run_or_raise("/tmp/builds/reven/release/output/axion/axion", { instance = "axion" }) end),
   awful.key({               }, "Print", function () run_or_raise("ksnapshot", { instance = "ksnapshot" }) end)
)
