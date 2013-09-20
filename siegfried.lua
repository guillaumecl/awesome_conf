
terminal = "urxvt"
customtags = true

for s = 1, screen.count() do
   -- Each screen has its own tag table.
   tags[s] = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒"}, s, layouts[1])
   --
   -- "➓"
end

browser = "qupzilla"
browser_instance = { instance = "qupzilla" }



rules = {
   { rule = { instance = "emacs" },
     properties = { tag = tags[1][1] } },
   { rule = { instance = "ktorrent" },
     properties = { tag = tags[1][9] } },
   { rule = { instance = "cantata" },
     properties = { tag = tags[1][8] } }
}
