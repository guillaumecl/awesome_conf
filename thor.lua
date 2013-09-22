tags = {}

tags[1] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, 1, awful.layout.suit.tile.bottom)

customtags = true


globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ }, "XF86AudioLowerVolume", function ()
											 awful.util.spawn("amixer -M -c 0 -q sset Master 2-")
										  end),
   awful.key({ }, "XF86AudioRaiseVolume", function ()
											 awful.util.spawn("amixer -M -c 0 -q sset Master 2+")
										  end),
   awful.key({ }, "XF86AudioMute", function ()
									  awful.util.spawn("amixer -M -c 0 -q sset Master toggle")
								   end),
   awful.key({ }, "XF86Tools", function ()
									  awful.util.spawn(base .. "/toggle_matchbox.sh")
								   end),
   awful.key({ modkey,      }, "y", function ()
								 awful.util.spawn("/home/tortuxm/projets/build/tmpc/tmpc")
							  end),
   awful.key({ modkey,      }, "c", function ()
								 awful.util.spawn("/home/tortuxm/projets/build/tmpc/tmpc --current")
							  end)
)

browser = "qupzilla -nw"
browser_instance = { instance = "qupzilla" }


filer = "rox"
filer_instance = { instance = "rox" }





rules = {
   { rule = { name = "Keyboard" },
	 callback =  function(c)
		awful.client.setslave(c)
   end }
}
