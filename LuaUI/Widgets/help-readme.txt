If you have the previous version installed you need to remove it first!!! Delete help.lua and HelpWidget folder.

Script.LuaUI.setPageOptions(options) - allows you to change the font size, colors, widget position and many other things
Script.LuaUI.displayPage(page) - displays the page
Script.LuaUI.isHelpVisible() - true if a page is displayed
Script.LuaUI.setWelcomePage(page) - this page will be shown only once

See gui_help_api.lua for avaliable options.
See gui_example_help.lua (disabled by default) for an example.

You can use "/luaui redraw" to redraw your currently opened page.

Syntax is very strict. All attributes are required. For example:
Correct:
<title=title>
Wrong:
<title = title>
<title="title">
<title=title />

These tags are supported:
<title=title>
<link=address>text</link> - equivalent to <a href> 
<image=image.png align=left|right|center width=pixels height=pixels>
<heading=fontsize> - equivalent to <h1>, <h2> ...
<li>
<include=page>