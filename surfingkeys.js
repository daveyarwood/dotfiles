// set theme
settings.theme = `
.sk_theme {
  font-family: Input Sans Condensed, Charcoal, sans-serif;
  font-size: 10pt;
  background: #24272e;
  color: #abb2bf;
}
.sk_theme tbody {
  color: #fff;
}
.sk_theme input {
  color: #d0d0d0;
}
.sk_theme .url {
  color: #61afef;
}
.sk_theme .annotation {
  color: #56b6c2;
}
.sk_theme .omnibar_highlight {
  color: #528bff;
}
.sk_theme .omnibar_timestamp {
  color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
  color: #98c379;
}
.sk_theme #sk_omnibarSearchResult>ul>li:nth-child(odd) {
  background: #303030;
}
.sk_theme #sk_omnibarSearchResult>ul>li.focused {
  background: #3e4452;
}
#sk_status, #sk_find {
  font-size: 20pt;
}`;

settings.blacklist = {
  "https://airtable.com": 1,
  "https://docs.google.com": 1,
  "https://issues.sonatype.org": 1,
  "https://www.meetup.com": 1,
  "https://www.reddit.com": 1
}

Hints.characters = "aoeuhtnsid',.pgcrlyf;qjkbwvzx"; // dvorak-style

mapkey('ch', 'Open ClubHouse story', function() {
  Front.openOmnibar({type: 'URLs', pref: "https://app.clubhouse.io/adzerk/story/"});
});

// disable "x" closing the tab. The "x" key in the Dvorak layout is hazardously
// close to the mouse cursor nipple on my Thinkpad, making it all too easy for
// my finger to slip and close the tab I'm on. I always use Ctrl-w anyway out of
// habit.
unmap("x");

// J and K move left/right through tabs
map("J", "E");
map("K", "R");

// H and L move backward/forward through history of current tab
map("H", "S");
map("L", "D");

// F is like f, but opens the link in a new, unfocused tab
map("F", "gf");

// mf lets you more conveniently open multiple links in new, unfocused tabs
map("mf", "cf");

// disable emoji completion
iunmap(":");
