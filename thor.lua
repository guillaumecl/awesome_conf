
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
   awful.key({ modkey,      }, "y", function ()
								 awful.util.spawn("/home/tortuxm/projets/build/tmpc/tmpc")
							  end),
   awful.key({ modkey,      }, "c", function ()
								 awful.util.spawn("/home/tortuxm/projets/build/tmpc/tmpc --current")
							  end)
)

browser = "qupzilla"
browser_instance = { instance = "qupzilla" }


filer = "rox"
filer_instance = { instance = "rox" }
