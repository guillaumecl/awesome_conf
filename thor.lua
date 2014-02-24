tags = {}

tags[1] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, 1, awful.layout.suit.tile.bottom)

customtags = true


globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ }, "XF86AudioLowerVolume", function ()
				awful.util.spawn("amixer -M -c 0 -q sset Master 2dB-")
   end),
   awful.key({ }, "XF86AudioRaiseVolume", function ()
				awful.util.spawn("amixer -M -c 0 -q sset Master 2dB+")
   end),
   awful.key({ }, "XF86AudioMute", function ()
				awful.util.spawn("amixer -M -c 0 -q sset Master toggle")
   end),

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

   awful.key({ }, "XF86Tools", function ()
				awful.util.spawn(base .. "/toggle_matchbox.sh")
   end),
   awful.key({ modkey,      }, "y", function ()
				run_or_raise("bash -c 'cd /home/tortuxm/projets/build/tmpc; ./tmpc'", { instance = "tmpc" } )
   end),
   awful.key({ modkey, "Control" }, "y", function ()
				run_or_raise("bash -c 'cd /home/tortuxm/projets/build/tmpc; ./tmpc -hodin'", { instance = "tmpc" } )
   end),
   awful.key({ modkey,      }, "c", function ()
				awful.util.spawn("bash -c 'cd /home/tortuxm/projets/build/tmpc; ./tmpc -c'")
   end),
   awful.key({ modkey, "Control" }, "c", function ()
				awful.util.spawn("bash -c 'cd /home/tortuxm/projets/build/tmpc; ./tmpc -c -hodin'")
   end)
)

browser = "firefox-bin -nw"
browser_instance = { instance = "Navigator" }


filer = "rox"
filer_instance = { instance = "rox" }





rules = {
   { rule = { name = "Keyboard" },
	 callback =  function(c)
		awful.client.setslave(c)
   end },
   {
	  rule = { class = "qemu-system-i386" },
	  properties = {
		 fullscreen = true,
		 maximized = true,
		 width=1024,
		 height=600
	  }
   },
}
