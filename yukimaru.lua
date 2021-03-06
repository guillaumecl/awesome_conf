tags = {}

tags[1] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, 1, awful.layout.suit.tile.bottom)
if screen.count() == 2 then
   tags[2] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, 2, awful.layout.suit.tile.bottom)
end

customtags = true

globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ }, "XF86AudioLowerVolume", function ()
				awful.util.spawn("ssh raspberyl amixer -M -c 0 -q sset PCM 2dB-")
   end),
   awful.key({  }, "XF86AudioRaiseVolume", function ()
				awful.util.spawn("ssh raspberyl amixer -M -c 0 -q sset PCM 2dB+")
   end),
   awful.key({  }, "XF86AudioMute", function ()
				awful.util.spawn("ssh raspberyl amixer -M -c 0 -q sset PCM toggle")
   end),

   awful.key({ modkey, "Control" }, "Return", function ()
				awful.util.spawn("ssh raspberyl mpc toggle")
   end),
   awful.key({ modkey, "Control" }, "Right", function ()
				awful.util.spawn("ssh raspberyl mpc next")
   end),
   awful.key({ modkey, "Control" }, "Left", function ()
				awful.util.spawn("ssh raspberyl mpc prev")
   end),
   awful.key({ modkey, "Control" }, "Up", function ()
				awful.util.spawn("ssh raspberyl amixer -M -c 0 -q sset PCM 2dB+")
   end),
   awful.key({ modkey, "Control" }, "Down", function ()
				awful.util.spawn("ssh raspberyl amixer -M -c 0 -q sset PCM 2dB-")
   end),

   awful.key({ modkey }, "y", function ()
				run_or_raise("bash -c 'cd /home/tortuxm/projets/tmpc/build; ./tmpc -hraspberyl'", { instance = "tmpc" } )
   end),
   awful.key({ modkey }, "c", function ()
				awful.util.spawn("bash -c 'cd /home/tortuxm/projets/tmpc/build; ./tmpc -c -hraspberyl'")
   end),
   awful.key({ modkey, "Control" }, "y", function ()
				run_or_raise("bash -c 'cd /home/tortuxm/projets/tmpc/build; ./tmpc -hraspberyl'", { instance = "tmpc" } )
   end),
   awful.key({ modkey, "Control" }, "c", function ()
				awful.util.spawn("bash -c 'cd /home/tortuxm/projets/tmpc/build; ./tmpc -c -hraspberyl'")
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
--		 fullscreen = true,
		 width=1024,
		 height=600
	  }
   },
}
