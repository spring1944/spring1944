local title = 'S:44'
local color = {
	white = {1,1,1,1},
	yellow = {1,1,0,1},
	gray = {0.5,.5,.5,1},
	darkgray = {0.3,.3,.3,1},
	cyan = {0,1,1,1},
	red = {1,0,0,1},
	darkred = {0.5,0,0,1},
	blue = {0,0,1,1},
	black = {0,0,0,1},
	
	postit = {1,0.9,0.5,1},
	brown = {0.17,0.14,0.08,1},
	
	grayred = {0.5,0.4,0.4,1},
	grayblue = {0.4,0.4,0.45,1},
	transblack = {0,0,0,0.3},
	
	parched = {0.9,0.8,0.4,0.99},
	olive = {0.27,0.27,0.13,0.9},
	darkgreen = {0.1,0.2,0.1,0.9},
}

color.main_bg = color.darkgreen
color.main_fg = color.white

color.menu_bg = color.olive
color.menu_fg = color.parched

color.game_bg = color.parched
color.game_fg = color.black


color.tooltip_bg = color.brown
color.tooltip_fg = color.parched

color.vol_bg = color.main_bg
color.vol_fg = color.parched

color.sub_bg	= color.main_bg
color.sub_fg = color.parched
color.sub_header = color.white

color.sub_button_bg = color.menu_bg
color.sub_button_fg = color.menu_fg

color.sub_back_bg = color.menu_bg
color.sub_back_fg = color.menu_fg

color.sub_close_bg = color.brown
color.sub_close_fg = color.menu_fg

color.stats_bg = color.sub_bg
color.stats_fg = color.sub_fg
color.stats_header = color.sub_header


color.context_bg = color.sub_bg
color.context_fg = color.sub_fg
color.context_header = color.sub_header


local multiweapon = false
--[[
local multiweapon = 
{
	armaak = {2,3},
	armfig = {1,2},
}
--]]
local iconFormat = '.tga'
return color, multiweapon, title, iconFormat