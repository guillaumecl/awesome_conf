

globalkeys = awful.util.table.join(
   globalkeys,

   awful.key({ "Control", "Mod1" }, "l", function () awful.util.spawn("xscreensaver-command -lock") end)
)


