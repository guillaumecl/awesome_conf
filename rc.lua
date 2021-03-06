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

--- Spawns cmd if no client can be found matching properties
-- If such a client can be found, pop to first tag where it is visible, and give it focus
-- @param cmd the command to execute
-- @param properties a table of properties to match against clients.  Possible entries: any properties of the client object
function run_or_raise(cmd, properties)
   local clients = client.get()
   local focused = awful.client.next(0)
   local findex = 0
   local matched_clients = {}
   local n = 0
   for i, c in pairs(clients) do
      --make an array of matched clients
      if match(properties, c) then
         n = n + 1
         matched_clients[n] = c
         if c == focused then
            findex = n
         end
      end
   end
   if n > 0 then
      local c = matched_clients[1]
      -- if the focused window matched switch focus to next in list
      if 0 < findex and findex < n then
         c = matched_clients[findex+1]
      end
      local ctags = c:tags()
      if #ctags == 0 then
         -- ctags is empty, show client on current tag
         local curtag = awful.tag.selected()
         awful.client.movetotag(curtag, c)
      else
         -- Otherwise, pop to first tag client is visible on
         awful.tag.viewonly(ctags[1])
         awful.screen.focus(awful.tag.getproperty(ctags[1], "screen"))
      end
      -- And then focus the client
      client.focus = c
      c:raise()
      return
   end
   awful.util.spawn(cmd)
end

-- Returns true if all pairs in table1 are present in table2
function match (table1, table2)
   for k, v in pairs(table1) do
      if not table2[k] then
         return false
      end
      if table2[k] ~= v and not table2[k]:find(v) then
         return false
      end
   end
   return true
end


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

browser = "firefox"
browser_instance = { instance = "Navigator" }

filer = "dolphin"
filer_instance = { instance = "dolphin" }

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

customtags = false
tags = {}
rules = awful.util.table.join()
globalkeys = awful.util.table.join()
clientkeys = awful.util.table.join()



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
         mytaglist[s],
         mypromptbox[s],
         layout = awful.widget.layout.horizontal.leftright
      },
      mylayoutbox[s],
      mytextclock,
      s == screen.count() and mysystray or nil,
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
   awful.key({ modkey,           }, "Up", function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "Down", function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
   awful.key({ modkey,           }, "Tab",
             function ()
                awful.client.focus.history.previous()
                if client.focus then
                   client.focus:raise()
                end
             end),

   -- Standard program
   awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
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

   awful.key({                   }, "XF86AudioNext",function () awful.util.spawn( "mpc next" ) end),
   awful.key({                   }, "XF86AudioPrev",function () awful.util.spawn( "mpc prev" ) end),
   awful.key({ "Shift"           }, "XF86AudioPrev",function () awful.util.spawn( "mpc seek -00:00:05" ) end),
   awful.key({ "Shift"           }, "XF86AudioNext",function () awful.util.spawn( "mpc seek +00:00:05" ) end),
   awful.key({                   }, "XF86AudioPlay",function () awful.util.spawn( "mpc toggle" ) end),
   awful.key({                   }, "XF86AudioStop",function () awful.util.spawn( "mpc stop" ) end),

   awful.key({ modkey            }, "e",function () run_or_raise(editor_cmd, { instance = "emacs" } ) end),
   awful.key({ modkey, "Shift"   }, "e",function () awful.util.spawn(editor_cmd ) end),

   awful.key({ modkey            }, "a",function () run_or_raise(terminal .. " -e emacsclient -c -a '' -nw", { name = "emacs", instance="urxvt" } ) end),
   awful.key({ modkey, "Shift"   }, "a",function () awful.util.spawn(terminal .. " -e emacsclient -c -a '' -nw" ) end),

   awful.key({ modkey            }, "d",function () run_or_raise(filer, filer_instance ) end),
   awful.key({ modkey, "Shift"   }, "d",function () awful.util.spawn(filer ) end),

   awful.key({ modkey            }, "w",function () run_or_raise( browser, browser_instance ) end),
   awful.key({ modkey, "Shift"   }, "w",function () awful.util.spawn( browser ) end),

   awful.key({ modkey,           }, "i", function () run_or_raise(terminal .. " -e irssi", { name = "irssi" } ) end),

   awful.key({ modkey            }, "z",function () run_or_raise("psi", { class="psi", instance="main" } ) end),
   awful.key({ modkey            }, "s",function () run_or_raise("psi", { class="psi", instance="chat" } ) end),

   awful.key({ modkey, "Shift"   }, "Right",function () awful.util.spawn( "mpc next" ) end),
   awful.key({ modkey, "Shift"   }, "Left",function () awful.util.spawn( "mpc prev" ) end),
   awful.key({ modkey, "Shift"   }, "Return",function () awful.util.spawn( "mpc toggle" ) end),

   awful.key({ modkey, "Shift"   }, "Down", function () awful.util.spawn("amixer -q sset Master 2dB-") end),
   awful.key({ modkey, "Shift"   }, "Up", function () awful.util.spawn("amixer -q sset Master 2dB+") end),


   awful.key({                   }, "XF86Calculator",function () run_or_raise( "kcalc", { instance = "kcalc" } ) end),
   awful.key({                   }, "XF86Mail",function () run_or_raise( "kmail", { instance = "kmail" } ) end),
   awful.key({ "Shift"           }, "XF86Mail",function () awful.util.spawn( "kmail --composer" ) end),

   awful.key({                   }, "XF86HomePage",function () run_or_raise( browser, browser_instance ) end),
   awful.key({ "Shift"           }, "XF86HomePage",function () awful.util.spawn( browser ) end),

   awful.key({ modkey, "Control" }, "n", awful.client.restore),

   -- Prompt
   awful.key({ modkey            }, "r", function ()
				mywibox[mouse.screen].visible = true
				mypromptbox[mouse.screen]:run()
   end),

   awful.key({ modkey, "Shift"   }, "x",
             function ()
                awful.prompt.run({ prompt = "Run Lua code: " },
                                 mypromptbox[mouse.screen].widget,
                                 awful.util.eval, nil,
                                 awful.util.getdir("cache") .. "/history_eval")
             end),

   awful.key({ modkey            }, "b", function ()
                                 mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
                              end),


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
   { rule = { class = "URxvt" },
     properties = { border_width = 0 },
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
   { rule = { class = "Tmpc" },
     properties = { floating = true } },
   { rule = { class = "Bloblines" },
     properties = { floating = true } },
   { rule = { class = "dosbox" },
     properties = { floating = false } },
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
					 if awful.client.floating.get(c) and (not c.name or (c.instance ~= "tmpc" and c.instance ~= "Bloblines")) then
						awful.titlebar.add(c, { modkey = modkey })
					 end
                     -- Enable sloppy focus
                     --                               c:add_signal("mouse::enter", function(c)
                     --                                                               if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                     --                                                               and awful.client.focus.filter(c) then
                     --                                                               client.focus = c
                     --                                                            end
                     --                                                         end)

                     -- put this in your "manage" signal handler
                     c:add_signal("property::urgent",
                                  function(c)
                                     if c.urgent and c.name then
                                        -- Show a popup notification with the window title
                                        naughty.notify({text="Urgent: " .. c.name})
                                     end
                     end)
                     -- Signal function to execute when client float property changes
                     c:add_signal("property::floating", function(c)
                                     if awful.client.floating.get(c) then
                                        awful.titlebar.add(c, { modkey = modkey })
                                     else
                                        awful.titlebar.remove(c)
                                     end
                     end)

                     if c.class and c.class == "psi" then
                        awful.client.setslave(c)
                     end

                     if c.class and c.class == "URxvt" then
                        if c.name and c.name ~= "irssi" then
                           awful.client.setslave(c)
                        end
                     end

                     if not startup then
                        -- Set the windows at the slave,
                        -- i.e. put it at the end of others instead of setting it master.

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
