settings.blacklist = {
    "https://airtable.com": 1,
    "https://docs.google.com": 1,
    "https://www.meetup.com": 1,
    "https://www.reddit.com": 1
}

// an example to create a new mapping `ctrl-y`
mapkey('<Ctrl-y>', 'Show me the money', function() {
    Front.showPopup('a well-known phrase uttered by characters in the 1996 film Jerry Maguire (Escape to close).');
});

// J and K move left/right through tabs
map("J", "E");
map("K", "R");

// H and L move backward/forward through history of current tab
map("H", "S");
map("L", "D");

// F is like f, but opens the link in a new, unfocused tab
map("F", "gf");

// disable emoji completion
iunmap(":");

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

Hints.characters = "aoeuhtnsid',.pgcrlyf;qjkbwvzx"; // dvorak-style
