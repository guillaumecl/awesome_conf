-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

-- {{{ Handle runtime errors after startup
do
   local in_error = false
   awesome.add_signal("debug::error", function (err)
                                         -- Make sure we don't go into an endless error loop
                                         if in_error then return end
                                         in_error = true

                                         naughty.notify({ preset = naughty.config.presets.critical,
                                                          title = "Oops, an error happened!",
                                                          text = err })
                                         in_error = false
                                      end)
end
-- }}}

function hostname()
   local f = io.popen ("/bin/hostname")
   local n = f:read("*a") or "none"
   f:close()
   n=string.gsub(n, "\n$", "")
   return(n)
end

base = awful.util.getdir("config")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(base .. "/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("VISUAL") or "emacsclient -c -a ''"
editor_cmd = "emacsclient -c -a ''"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

customtags = false
custommenu = false
tags = {}
rules = awful.util.table.join()
globalkeys = awful.util.table.join()
clientkeys = awful.util.table.join()
mainmenu = {}



-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
   {
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.fair,
   awful.layout.suit.fair.horizontal,
   awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
   awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier,
   awful.layout.suit.floating
}
-- }}}


require(hostname())

if not customtags then
   -- {{{ Tags
   -- Define a tag table which hold all screen tags.
   for s = 1, screen.count() do
      -- Each screen has its own tag table.
      tags[s] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, s, layouts[1])
      --
      -- "➓"
   end
   -- }}}
end

-- {{{ Menu
-- Create a laucher widget and a main menu
if not custommenu then
   submenu = {
      { "manual", terminal .. " -e man awesome" },
      { "edit config", editor_cmd .. " " .. awesome.conffile },
      { "restart", awesome.restart },
      { "quit", awesome.quit }
   }


   mainmenu = awful.menu({ items = { { "awesome", submenu, beautiful.awesome_icon },
                                     { "open terminal", terminal }
                                  }
                        })
end

launcher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                   menu = mainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, "%H:%M ", 60)

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
                           if c == client.focus then
                              c.minimized = true
                           else
                              if not c:isvisible() then
                                 awful.tag.viewonly(c:tags()[1])
                              end
                              -- This will also un-minimize
                              -- the client, if needed
                              client.focus = c
                              c:raise()
                           end
                        end),
   awful.button({ }, 3, function ()
                           if instance then
                              instance:hide()
                              instance = nil
                           else
                              instance = awful.menu.clients({ width=250 })
                           end
                        end),
   awful.button({ }, 4, function ()
                           awful.client.focus.byidx(1)
                           if client.focus then client.focus:raise() end
                        end),
   awful.button({ }, 5, function ()
                           awful.client.focus.byidx(-1)
                           if client.focus then client.focus:raise() end
                        end))

for s = 1, screen.count() do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
                             awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(function(c)
                                            return awful.widget.tasklist.label.currenttags(c, s)
                                         end, mytasklist.buttons)

   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "top", screen = s })
   -- Add widgets to the wibox - order matters
   mywibox[s].widgets = {
      {
         launcher,
         mytaglist[s],
         mypromptbox[s],
         layout = awful.widget.layout.horizontal.leftright
      },
      mylayoutbox[s],
      mytextclock,
      s == 1 and mysystray or nil,
      mytasklist[s],
      layout = awful.widget.layout.horizontal.rightleft
   }
   mywibox[s].visible = false
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
--                awful.button({ }, 3, function () mainmenu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
          ))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),

   awful.key({ modkey,           }, "j",
             function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
             end),
   awful.key({ modkey,           }, "k",
             function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
             end),
--   awful.key({ modkey,           }, "w", function () mainmenu:show({keygrabber=true}) end),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
   awful.key({ modkey,           }, "Tab",
             function ()
                awful.client.focus.history.previous()
                if client.focus then
                   client.focus:raise()
                end
             end),

   -- Standard program
   awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal .. " -e bash -c 'cd; bash'") end),
   awful.key({ modkey, "Control" }, "r", awesome.restart),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit),

   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
   awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

   awful.key({ modkey,           }, "F1", function () awful.util.spawn(base .. "/changeInput.sh fr") end),
   awful.key({ modkey,           }, "F2", function () awful.util.spawn(base .. "/changeInput.sh fr bepo") end),
   awful.key({ modkey,           }, "F3", function () awful.util.spawn(base .. "/changeInput.sh us") end),

   awful.key({ }, "XF86AudioNext",function () awful.util.spawn( "mpc next" ) end),
   awful.key({ }, "XF86AudioPrev",function () awful.util.spawn( "mpc prev" ) end),
   awful.key({ "Shift" }, "XF86AudioPrev",function () awful.util.spawn( "mpc seek -00:00:05" ) end),
   awful.key({ "Shift" }, "XF86AudioNext",function () awful.util.spawn( "mpc seek +00:00:05" ) end),
   awful.key({ }, "XF86AudioPlay",function () awful.util.spawn( "mpc toggle" ) end),
   awful.key({ }, "XF86AudioStop",function () awful.util.spawn( "mpc stop" ) end),
   awful.key({ modkey            }, "e",function () awful.util.spawn( editor_cmd ) end),
   awful.key({ modkey            }, "d",function () awful.util.spawn( "dolphin" ) end),
   awful.key({ modkey            }, "w",function () awful.util.spawn( "firefox" ) end),

   awful.key({ modkey, "Shift"   }, "Right",function () awful.util.spawn( "mpc next" ) end),
   awful.key({ modkey, "Shift"   }, "Left",function () awful.util.spawn( "mpc prev" ) end),
   awful.key({ modkey, "Shift"   }, "Return",function () awful.util.spawn( "mpc toggle" ) end),
   --   awful.key({ modkey, "Shift"   }, "Backspace",function () awful.util.spawn( "mpc stop" ) end),
   awful.key({ modkey, "Shift"   }, "Down", function () awful.util.spawn("amixer -q sset Master 2dB-") end),
   awful.key({ modkey, "Shift"   }, "Up", function () awful.util.spawn("amixer -q sset Master 2dB+") end),


   awful.key({ }, "XF86Calculator",function () awful.util.spawn( "kcalc" ) end),
   awful.key({ }, "XF86Mail",function () awful.util.spawn( "kmail" ) end),
   awful.key({ }, "XF86HomePage",function () awful.util.spawn( "x-www-browser" ) end),

   awful.key({ modkey, "Control" }, "n", awful.client.restore),

   -- Prompt
   awful.key({ modkey },            "r",     function ()
												mywibox[mouse.screen].visible = true
                                                mypromptbox[mouse.screen]:run()
                                             end),

   awful.key({ modkey }, "x",
             function ()
                awful.prompt.run({ prompt = "Run Lua code: " },
                                 mypromptbox[mouse.screen].widget,
                                 awful.util.eval, nil,
                                 awful.util.getdir("cache") .. "/history_eval")
             end),
   awful.key({ modkey }, "b", function ()
                                 mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
                              end),


   awful.key({ "Mod1" ,           }, "F1", function () awful.util.spawn("plasmoidviewer launcher") end),
   awful.key({ "Mod1"             }, "F3", function () awful.util.spawn("plasmoidviewer calendar") end),
   globalkeys
)

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey,           }, "Escape", function (c) c:kill()                         end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
   awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "n",
             function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
             end),
   awful.key({ modkey,           }, "m",
             function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
             end),
   clientkeys
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
   globalkeys = awful.util.table.join(globalkeys,
                                      awful.key({ modkey }, "#" .. i + 9,
                                                function ()
                                                   local screen = mouse.screen
                                                   if tags[screen][i] then
                                                      awful.tag.viewonly(tags[screen][i])
                                                   end
                                                end),
                                      awful.key({ modkey, "Control" }, "#" .. i + 9,
                                                function ()
                                                   local screen = mouse.screen
                                                   if tags[screen][i] then
                                                      awful.tag.viewtoggle(tags[screen][i])
                                                   end
                                                end),
                                      awful.key({ modkey, "Shift" }, "#" .. i + 9,
                                                function ()
                                                   if client.focus and tags[client.focus.screen][i] then
                                                      awful.client.movetotag(tags[client.focus.screen][i])
                                                   end
                                                end),
                                      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                                function ()
                                                   if client.focus and tags[client.focus.screen][i] then
                                                      awful.client.toggletag(tags[client.focus.screen][i])
                                                   end
                                                end))
end

-- Set keys
root.keys(globalkeys)

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- }}}

-- {{{ Rules
baserules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = true,
                    keys = clientkeys,
                    buttons = clientbuttons,
                    size_hints_honor = false,
                    maximized_vertical   = false,
                    maximized_horizontal = false
                 }
  },
   { rule = { class = "MPlayer" },
     properties = { floating = true } },
   { rule = { class = "Kcalc" },
     properties = { floating = true } },
   { rule = { instance = "plasma-desktop" },
     properties = { floating = true } },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   { rule = { class = "kmail" },
     properties = { tag = tags[1][2] } },
   { rule = { class = "amarok" },
     properties = { tag = tags[1][2] } },
   { rule = { class = "Plasmoidviewer" },
	 properties = {
		floating = true,
		keys = awful.util.table.join(clientkeys,
									 awful.key({ }, "Escape", function (c)
                                                                 c:kill()
                                                              end))
     }
   },
}

awful.rules.rules = awful.util.table.join(
   baserules,
   rules
)

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
                               -- Add a titlebar
                               -- awful.titlebar.add(c, { modkey = modkey })

                               -- Enable sloppy focus
--                               c:add_signal("mouse::enter", function(c)
--                                                               if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--                                                               and awful.client.focus.filter(c) then
--                                                               client.focus = c
--                                                            end
--                                                         end)

                               if not startup then
                                  -- Set the windows at the slave,
                                  -- i.e. put it at the end of others instead of setting it master.
                                  -- awful.client.setslave(c)

                                  -- Put windows in a smart way, only if they does not set an initial position.
                                  if not c.size_hints.user_position and not c.size_hints.program_position then
                                     awful.placement.no_overlap(c)
                                     awful.placement.no_offscreen(c)
                                  end
                               end
                            end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
