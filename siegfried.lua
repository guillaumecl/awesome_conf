
terminal = "urxvtc"
customtags = true

for s = 1, screen.count() do
   -- Each screen has its own tag table.
   tags[s] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, s, layouts[1])
   --
   -- "➓"
end


globalkeys = awful.util.table.join(
   globalkeys,

   awful.key({ "Control"}, "XF86AudioLowerVolume", function ()
				awful.util.spawn("ssh odin amixer -M -c 0 -q sset Master 2-")
   end),
   awful.key({ "Control" }, "XF86AudioRaiseVolume", function ()
				awful.util.spawn("ssh odin amixer -M -c 0 -q sset Master 2+")
   end),
   awful.key({ "Control" }, "XF86AudioMute", function ()
				awful.util.spawn("ssh odin amixer -M -c 0 -q sset Master toggle")
   end),

   awful.key({ modkey, "Control" }, "Return", function ()
				awful.util.spawn("ssh odin mpc toggle")
   end),
   awful.key({ modkey, "Control" }, "Right", function ()
				awful.util.spawn("ssh odin mpc next")
   end),
   awful.key({ modkey, "Control" }, "Left", function ()
				awful.util.spawn("ssh odin mpc prev")
   end),
   awful.key({ modkey, "Control"}, "Up", function ()
				awful.util.spawn("ssh odin amixer -M -c 0 -q sset Master 2dB+")
   end),
   awful.key({ modkey, "Control" }, "Down", function ()
				awful.util.spawn("ssh odin amixer -M -c 0 -q sset Master 2dB-")
   end),

   awful.key({ modkey,      }, "y", function ()
				run_or_raise("bash -c 'cd /home/tortuxm/projets/tmpc/build; ./tmpc'", { instance = "tmpc" } )
   end),
   awful.key({ modkey, "Control" }, "y", function ()
				run_or_raise("bash -c 'cd /home/tortuxm/projets/tmpc/build; MPD_HOST=odin ./tmpc'", { instance = "tmpc" } )
   end),
   awful.key({ modkey,      }, "c", function ()
				awful.util.spawn("bash -c 'cd /home/tortuxm/projets/tmpc/build; ./tmpc --current'")
   end),
   awful.key({ modkey, "Control" }, "c", function ()
				awful.util.spawn("bash -c 'cd /home/tortuxm/projets/tmpc/build; MPD_HOST=odin ./tmpc --current'")
   end)
)


