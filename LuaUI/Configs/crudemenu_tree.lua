local spSendCommands = Spring.SendCommands

local game_menu_tree = {
	{'Pause/Unpause', function(self) spSendCommands{"pause"} end },
	{},
	{'Share Dialog...', function(self) spSendCommands{"sharedialog"} end },	
	{'Autogroup', 
		{
			{'Clear Groups', function(self) spSendCommands{"luaui autogroup cleargroups"} end },
			{'Toggle Load Groups', function(self) spSendCommands{"luaui autogroup loadgroups"} end },
			{'Toggle Verbose', function(self) spSendCommands{"luaui autogroup verbose"} end },
			{'Toggle Add All', function(self) spSendCommands{"luaui autogroup addall"} end },
			{},
			{
				'Help',
				'Autogroup is a widget that places newly built units into groups you can quickly define with keyboard shortcuts. '..
				'Alt+0-9 sets an number for the unit type(s) you currently have selected. When a new unit is built, it gets added to the group based on this autogroup.'..
				'Alt+\~ deletes the autogrouping for the selected unit type(s).'..
				'Ctrl+~ removes the nearest selected unit from its group and selects it. '
				
			},
		}
	},
	{'Minimap Icon Colors'},
	{'Team Colors', function(self) spSendCommands{"minimap simplecolors 0"} end },
	{'Simple Colors', function(self) spSendCommands{"minimap simplecolors 1"} end },
	{'Views'},
	{'Line of Sight'},
	{'Toggle Fog of War', function(self) spSendCommands{"togglelos"} end },
	{'Toggle Radar/Jammer', function(self) spSendCommands{"toggleradarandjammer"} end },	
	
	{'Map Views'},
	{'Normal', function(self) spSendCommands{"showstandard"} end },	
	{'Toggle Metal Map', function(self) spSendCommands{"ShowMetalMap"} end },
	{'Toggle Elevation', function(self) spSendCommands{"showelevation"} end },	
	{'Toggle Pathing', function(self) spSendCommands{"showpathmap"} end },
	

}

local menu_tree = {
	{'Help', 
		{
			{
				'Tips',
				'Hold your meta-key (spacebar by default) while clicking on a unit or corpse for more info and options. '..
				'You can also space-click on menu elements to see context settings. '..
				'Enjoy.'
			},
		}
	},
	{'Actions',
		{
			{'Save Screenshot', function() spSendCommands{"screenshot"} end },	
		}
	},
	{'Settings',
		{
			{'Language...', ShowFlags },	
			{'Lowest Settings', 
				{
					{'Reset all settings to minimum.'},
					{
						'Reset', 
						function()
							spSendCommands{"water 0"}
							spSendCommands{"Shadows 0"} 
							spSendCommands{"maxparticles 1000"}
							spSendCommands{"advshading 0"}
							spSendCommands{"grounddecals 0"}
							spSendCommands{'luaui disablewidget LupsManager'}
							spSendCommands{"luaui disablewidget Display DPS"}
						end },
				}
			},	
			{'Video', 
				{
					{'View Radius'},
					{'Increase', function() spSendCommands{"increaseViewRadius"} end },	
					{'Decrease', function() spSendCommands{"decreaseViewRadius"} end },
					
					--vsync?
					
					{'Lups (Lua Particle System)'},
					{'Toggle', function() spSendCommands{'luaui togglewidget LupsManager'} end },	
					
					{'Trees'},
					{'Toggle View', function() spSendCommands{'drawtrees'} end },	
					{'See More', function() spSendCommands{'moretrees'} end },	
					{'See Less', function() spSendCommands{'lesstrees'} end },	
					--{'Toggle Dynamic Sky', function(self) spSendCommands{'dynamicsky'} end },	
					{},
					{'Toggle Shiny Units', function() spSendCommands{"advshading"} end },
					{'Toggle Ground Decals', function() spSendCommands{"grounddecals"} end },
					{'Graphic detail', 
						{
							{'Water Settings'},
							{'Basic', function() spSendCommands{"water 0"} end },
							{'Reflective', function() spSendCommands{"water 1"} end },
							{'Reflective and Refractive', function() spSendCommands{"water 2"} end },
							{'Dynamic', function() spSendCommands{"water 3"} end },
							{'Bumpmapped', function() spSendCommands{"water 4"} end },
							
							{'Shadow Settings'},
							{'Disable Shadows', function() spSendCommands{"Shadows 0"} end },
							{'Low Detail Shadows', function() spSendCommands{"Shadows 1 1024"} end },
							{'Medium Detail Shadows', function() spSendCommands{"Shadows 1 2048"} end },
							{'High Detail Shadows', function() spSendCommands{"Shadows 1 4096"} end },
							--{'Extreme Detail Shadows', function() spSendCommands{"Shadows 1 8192"} end },
							
							{'Particles On Screen'},
							{'1,000', function() spSendCommands{"maxparticles 1000"} end },
							{'5,000', function() spSendCommands{"maxparticles 5000"} end },
							{'10,000', function() spSendCommands{"maxparticles 10000"} end },
							{'20,000', function() spSendCommands{"maxparticles 20000"} end },
						}
					},
				}
			},
			{'View',
				{
					{'Spectator View/Selection'},
					{'View Chosen Player', function() spSendCommands{"specfullview 0"} end },
					{'View All', function() spSendCommands{"specfullview 1"} end },
					{'Select Any Unit', function() spSendCommands{"specfullview 2"} end },
					{'View All & Select Any', function() spSendCommands{"specfullview 3"} end },
					
					{'Camera Type'},
					{'Total Annihilation', function() spSendCommands{"viewta"} end },
					{'FPS', function() spSendCommands{"viewfps"} end },
					{'Free', function() spSendCommands{"viewfree"} end },
					{'Rotatable Overhead', function() spSendCommands{"viewrot"} end },
					{'Total War', function() spSendCommands{"viewtw"} end },

					{'tr_Icon Distance', {min = 1, max = 1000, action = function(self)	Spring.SendCommands{"disticon " .. self.value} end } },
					
					{'tr_Brightness', { min=1, max=0, step=-0.01, action = function(self) Spring.SendCommands{"luaui enablewidget Darkening", "luaui darkening " .. self.value} end } },
	
					{},
					{'Toggle Healthbars', function() spSendCommands{'showhealthbars'} end },	
					{'Toggle DPS Display', function() spSendCommands{"luaui togglewidget Display DPS"} end },
					{'Night', 
						{
							{'Toggles'},
							{'Night View', function() spSendCommands{'luaui togglewidget Night2'} end },
							{},
							{'Night Colored Units', function() spSendCommands{'luaui night_preunit'} end },
							{'Beam', function() spSendCommands{'luaui night_beam'} end },
							{'Cycle', function() spSendCommands{'luaui night_cycle'} end },
							{'Searchlight Base Types'},
							{'None', function() spSendCommands{'luaui night_basetype 0'} end },
							{'Simple', function() spSendCommands{'luaui night_basetype 1'} end },
							{'Full', function() spSendCommands{'luaui night_basetype 2'} end },
						}
					},
					
					--{'Hide Interface', function(self) spSendCommands{'hideinterface'} end },	
					--{'showshadowmap', function(self) spSendCommands{'showshadowmap'} end },	
				}
			},
			
			{'Menu', 
				{
					--[[
					{'Spring Build Menu',
						{
							{'Unit Icon Colors'},
							{'Colorized', function() 
								WG.Layout.colorized = true
								Spring.ForceLayoutUpdate()
								end },
							{'Black & White', function() 
								WG.Layout.colorized = false
								Spring.ForceLayoutUpdate()
								end },
							{'Commands to Show'},
							{'All', function() 
								WG.Layout.minimal = false
								Spring.ForceLayoutUpdate()
								end },
							{'Minimal', function() 
								WG.Layout.minimal = true
								Spring.ForceLayoutUpdate()
								end },
							{'ch_Hide Units', 'hideUnits' },
						}
					},
					{'Nested BuildMenu', 
						{
							{'Toggle Nested Buildmenu', function() spSendCommands{"luaui togglewidget Nested Buildmenu"} end },
							{},
							{'Toggle Return On Select', function() spSendCommands{"luaui nested_buildmenu_cancelonly"} end },
							{'tr_Size', { min=20, max=80, action=function(self) spSendCommands{"luaui nested_buildmenu_size " .. self.value } end } },
							{'tr_Columns', { 
									min=1, max=15, 
									action=function(self) 
										spSendCommands{"luaui nested_buildmenu_cols " .. self.value}
										echo('Nested BuildMenu set to ' .. self.value .. ' columns')
									end 
								} 
							},
							
						}
					},
					--]]
					{'Crude Menu',
						{
							{'ch_Horizontal Orientation', 'horizontal' },
							{},
							
							{'ch_Disable Volume Bar', 'noVolBar' },
							{},
							{'Meta Click Context Menu'},
							{'ch_Disable', 'noContextClick' },
						}	
					},
					
				}
			},
			{'Misc', 
				{
					--[[
					{'Mouse Settings',
						{
							{'Cursor Sets'},
							{'Complete Annihilation', function() cursorSet = RestoreCursor() end },
							{'CA Static', function() cursorSet = SetCursor("ca_static") end },
							{'Erom', function() cursorSet = SetCursor("erom") end },
							{'Masse', function() cursorSet = SetCursor("masse") end },
							{'Lathan', function() cursorSet = SetCursor("lathan") end },
							{'K_haos_girl', function() cursorSet = SetCursor("k_haos_girl") end },
						}
					},
					--]]
					{'Widget List...', ShowWidgetList2},
					{'LuaUI TweakMode (Esc to exit)', function() spSendCommands{"luaui tweakgui"} end },
					
				}
			},
		}
	},
	{'Quit Menu...', function() spSendCommands{"quitmenu"} end },
	{},
	{'Quit Now!', function() spSendCommands{"quitforce"} end},
}

return menu_tree, game_menu_tree