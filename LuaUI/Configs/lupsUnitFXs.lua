effectUnitDefs = {

	efighter = {
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=35, piece="engine", onActive=true}},
	},
	
	egunship2 = {
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=35, piece="engine", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="fengine1", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="fengine2", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="rengine1", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="rengine2", onActive=true}},
	},
	
	ebomber = {
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=40, piece="engine", onActive=true}},
	},
	
	eairengineer = {
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="fengine1", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="fengine2", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="rengine1", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="rengine2", onActive=true}},
	},
	
	escout = {
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=35, piece="flare", onActive=true}},
	},
	
	etransport = {
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="engine1", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=25, piece="engine2", onActive=true}},
	},
	
	esubplane = {
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  4, length=35, piece="engines", onActive=true}},
	},

	edrone = {
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  2, length=20, piece="engine1", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  2, length=15, piece="engine2", onActive=true}},
		{class='AirJet',	options={color={1,0.5,0.0,0.75},	width =  2, length=15, piece="engine3", onActive=true}},
	},
	esolar2 = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

		-- {class='Bursts', options=esolarBursts},
    -- {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,32,0}, size=10, precision=22, strength   = 0.02,  repeatEffect=true}},
  },
	emetalextractor = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
--    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,55,0}, size=10, precision=22, strength   = 0.015,  repeatEffect=true}},
  },
	euwmetalextractor = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
 --   {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,25,0}, size=15, precision=22, strength   = 0.015,  repeatEffect=true}},
  },
	egeothermal = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--		{class='Bursts', options=egeoBursts},
--    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,26,0.0}, size=10, precision=22, strength   = 0.02,  repeatEffect=true}},
  },
	efusion2 = {
--		{class='StaticParticles', options=corfusNova},
--		{class='StaticParticles', options=corfusNova2},
--		{class='StaticParticles', options=corfusNova3},
--		{class='StaticParticles', options=corfusNova4},

--		{class='StaticParticles',options=efusCorona},
--		{class='ShieldSphere',options=efusShieldSphere},

--		{class='Bursts', options=efusion2Bursts},
--    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,51,0.0}, size=23, precision=22, strength   = 0.02,  repeatEffect=true}},
  },
  
	burrow = {
--		{class='StaticParticles', options=corfusNova},
--		{class='StaticParticles', options=corfusNova2},
--		{class='StaticParticles', options=corfusNova3},
--		{class='StaticParticles', options=corfusNova4},

--		{class='StaticParticles',options=efusCorona},
--		{class='ShieldSphere',options=efusShieldSphere},

--		{class='Bursts', options=burrowBursts},
--    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,51,0.0}, size=23, precision=22, strength   = 0.02,  repeatEffect=true}},
  },
  
	eminifac = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,25,110}, size=75, precision=22, strength   = 0.015,  repeatEffect=true}},
  },
	ebasefactory = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
    {class='ShieldJitter', options={delay=0,life=math.huge, pos={20,25,10}, size=55, precision=22, strength   = 0.015,  repeatEffect=true}},
  },
	eamphibfac = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
--    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,25,85}, size=60, precision=22, strength   = 0.015,  repeatEffect=true}},
  },
	eairplant = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,280,30}, size=55, precision=22, strength   = 0.015,  repeatEffect=true}},
  },

	eexperimentalfac = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,50,0}, size=140, precision=22, strength   = 0.015,  repeatEffect=true}},
  },
  
	eshieldgen = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
--    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,60,0.0}, size=1500, precision=0, strength   = 0.0025, repeatEffect=true}},
  },
  
	eallterrshield = {
--    {class='StaticParticles', options=corfusNova},
--    {class='StaticParticles', options=corfusNova2},
--    {class='StaticParticles', options=corfusNova3},
--    {class='StaticParticles', options=corfusNova4},

--    {class='Bursts', options=efusion2Bursts},
--    {class='ShieldJitter', options={delay=0,life=math.huge, pos={0,60,0.0}, size=300, precision=0, strength   = 0.0025, repeatEffect=true}},
  },
	
	
	----// FUSIONS //--------------------------
	-- cafus = {
		-- {class='Bursts',options=cafusBursts},
		-- {class='StaticParticles',options=cafusCorona},
		-- {class='ShieldSphere',options=cafusShieldSphere},
		-- {class='ShieldJitter',	options={layer=-16, life=math.huge, pos={0,58.9,-4.5}, size=24.5, precision=22, repeatEffect=true}},
		-- {class='GroundFlash',options=groundFlashOrange},
	-- },
	-- corfus = {
		-- {class='StaticParticles',options=corfusNova},
		-- {class='StaticParticles',options=corfusNova2},
		-- {class='StaticParticles',options=corfusNova3},
		-- {class='StaticParticles',options=corfusNova4},

		-- {class='Bursts',options=corfusBursts},
		-- {class='ShieldJitter',	options={delay=0,life=math.huge, pos={0,40.5,0.0}, size=10, precision=22, repeatEffect=true}},
	-- },
	-- aafus = {
		-- {class='SimpleParticles2',options=MergeTable({piece="rod2", delay=30, lifeSpread=math.random()*20},sparks)},
		-- {class='SimpleParticles2',options=MergeTable({piece="rod4", delay=60, lifeSpread=math.random()*20},sparks)},
		-- {class='SimpleParticles2',options=MergeTable({piece="rod5", delay=90, lifeSpread=math.random()*20},sparks)},
		-- {class='SimpleParticles2',options=MergeTable({piece="rod7", delay=120, lifeSpread=math.random()*20},sparks)},

		-- {class='Sound',	options={repeatEffect=true, file="Sparks", blockfor=4.8*30, length=5.1*30}},
	-- },

	-----// SHIELDS //---------------------------
	-- corjamt = {
		-- {class='Bursts',options=corjamtBursts},
		-- {class='ShieldSphere',	options={life=math.huge, piece="sphere", size=11, colormap1 = {{0.8, 0.1, 0.8, 0.5}}, repeatEffect=true}},
		-- {class='GroundFlash',options=groundFlashViolett},
	-- },
	-- core_spectre = {
		-- {class='Bursts',options=MergeTable({piece="sphere"},corjamtBursts)},
		-- {class='ShieldSphere',	options={piece="sphere", life=math.huge, size=8, colormap1 = {{0.95, 0.1, 0.95, 0.9}}, repeatEffect=true}},
	-- },

	-----// ENERGY STORAGE //--------------------
	-- corestor = {
		-- {class='GroundFlash',options=groundFlashCorestor},
	-- },
	-- armestor = {
		-- {class='GroundFlash',options=groundFlashArmestor},
	-- },
  
	----// PYLONS // ----------------------------------
	-- mexpylon = {
		-- {class='GroundFlash',options=groundFlashCorestor},
	-- },

	----// OTHER
	-- roost = {
		-- {class='SimpleParticles',options=roostDirt},
		-- {class='SimpleParticles',options=MergeTable({delay=60},roostDirt)},
		-- {class='SimpleParticles',options=MergeTable({delay=120},roostDirt)},
	-- },
	-- corarad = {
		-- {class='StaticParticles',options=radarBlink},
		-- {class='StaticParticles',options=MergeTable(radarBlink,{pos={-1.6,25,0.0},delay=15})},
		-- {class='StaticParticles',options=MergeTable(radarBlink,{pos={0,21,-1.0},delay=30})},
	-- },
	-- corrad = {
		-- {class='StaticParticles',options=MergeTable(radarBlink,{piece="head"})},
		-- {class='StaticParticles',options=MergeTable(radarBlink,{piece="head", delay=15})},
	-- },

	-- armmex = {
		-- {class='AirJet',	options={color={1.0,0.1,0.1},	width =  1, length=30, piece="emit", onActive=false, emitVector={0,1.0,0.0}}},
	-- },


	----// SEA PLANES //----------------------------
	-- armsaber = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.7, length=25, piece="nozzle", onActive=true}},
	-- },
	-- armseap = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.7, length=30, piece="nozzle", onActive=true}},
	-- },
	-- armsehak = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.7, length=30, piece="nozzle", onActive=true}},
	-- },
	-- armsfig = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.3, length=30, piece="nozzle", onActive=true}},
	-- },
	-- armsb = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.7, length=70, piece="emit1", onActive=true}},
	-- },
	-- corsfig = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=32, piece="nozzle", onActive=true}},
	-- },
	-- corhunt = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  6.25, length=40, piece="nozzle", onActive=true}},
	-- },
	-- corseap = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=25, piece="nozzle1", onActive=true}},
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=25, piece="nozzle2", onActive=true}},
	-- },
	-- corsb = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=36, piece="emit1", onActive=true}},
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=36, piece="emit2", onActive=true}},
	-- },
	-- corcut = {
		-- {class='AirJet',	options={color={0.6,0.1,0.0},	width =  6, length=25, piece="rthrust1", onActive=true}},
		-- {class='AirJet',	options={color={0.6,0.1,0.0},	width =  6, length=25, piece="rthrust2", onActive=true}},
	-- },

	----// PLANES //----------------------------
	-- armfig = {
		-- {class='AirJet',	options={color={0.2,0.1,0.5},	width =  5, length=35, piece="ljet", onActive=true}},
		-- {class='AirJet',	options={color={0.2,0.1,0.5},	width =  5, length=35, piece="rjet", onActive=true}},
		-- {class='Ribbon',	options={width=1, size=8, piece="lwingtip"}},
		-- {class='Ribbon',	options={width=1, size=8, piece="rwingtip"}},
	-- },
	-- armhawk = {
		-- {class='AirJet',	options={color={0.2,0.1,0.5},	width =  5, length=35, piece="ljet", onActive=true}},
		-- {class='AirJet',	options={color={0.2,0.1,0.5},	width =  5, length=35, piece="rjet", onActive=true}},
		-- {class='AirJet',	options={color={0.2,0.1,0.5},	width =  5, length=35, piece="mjet", onActive=true}},
		-- {class='Ribbon',	options={width=1, size=8, piece="lwingtip"}},
		-- {class='Ribbon',	options={width=1, size=8, piece="rwingtip"}},
		-- {class='Ribbon',	options={width=1, size=8, piece="mwingtip"}},
	-- },
	-- armcybr = {
		-- {class='AirJet',	options={color={0.5,0.1,0.0},	width =  3.5, length=25, piece="nozzle1", onActive=true}},
		-- {class='AirJet',	options={color={0.5,0.1,0.0},	width =  3.5, length=25, piece="nozzle2", onActive=true}},
 	-- },
	-- armhawk2 = {
		-- {class='AirJet',	options={color={0.6,0.2,0.0},	width =  2.8, length=12, piece="enginel", onActive=true}},
		-- {class='AirJet',	options={color={0.6,0.2,0.0},	width =  2.8, length=12, piece="enginer", onActive=true}},
		-- {class='Ribbon',	options={width=1, size=12, piece="wingtip1"}},
		-- {class='Ribbon',	options={width=1, size=12, piece="wingtip2"}},
	-- },
	-- armbrawl = {
		-- {class='AirJet',	options={color={0.0,0.5,1.0},	width =  5, length=15, piece="lfjet", onActive=true}},
		-- {class='AirJet',	options={color={0.0,0.5,1.0},	width =  5, length=15, piece="rfjet", onActive=true}},
		-- {class='AirJet',	options={color={0.0,0.5,1.0},	width =  2.5, length=10, piece="lrjet", onActive=true}},
		-- {class='AirJet',	options={color={0.0,0.5,1.0},	width =  2.5, length=10, piece="rrjet", onActive=true}},
	-- },
	-- armawac = {
		-- {class='Ribbon',	options={color={.3,.3,01,1.0},	width =  5.5, piece="rjet"}},
		-- {class='Ribbon',	options={color={.3,.3,01,1.0},	width =  5.5, piece="ljet"}},
	-- },
	-- corgripn = {
		-- {class='AirJet',	options={color={0.5,0.1,0.0},	width =  3.5, length=35, piece="nozzle", onActive=true}},
	-- },

	-- armstiletto_laser = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=17, piece="jet1", onActive=true}},
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=17, piece="jet2", onActive=true}},
		-- {class='Ribbon',	options={width=1, size=6, piece="wingtip1"}},
		-- {class='Ribbon',	options={width=1, size=6, piece="wingtip2"}},
	-- },
	-- armcsa = {
		-- {class='AirJet',	options={color={0.45,0.45,0.9},	width =  2.8, length=12, piece="enginel", onActive=true}},
		-- {class='AirJet',	options={color={0.45,0.45,0.9},	width =  2.8, length=12, piece="enginer", onActive=true}},
		-- {class='Ribbon',	options={width=1, size=12, piece="wingtipl"}},
		-- {class='Ribbon',	options={width=1, size=12, piece="wingtipr"}},
	-- },

  	-- bladew = {
		-- {class='Ribbon',	options={width=1, size=5, piece="ljet"}},
		-- {class='Ribbon',	options={width=1, size=5, piece="rjet"}},	
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3, length=14, piece="ljet", onActive=true, emitVector = {0, 1, 0}}},
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3, length=14, piece="rjet", onActive=true, emitVector = {0, 1, 0}}},
	-- },

	-- armkam = {
		-- {class='Ribbon',	options={width=1, size=10, piece="lfx"}},
		-- {class='Ribbon',	options={width=1, size=10, piece="rfx"}},	
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  4, length=25, piece="lfx", onActive=true, emitVector = {0, 0, 1}}},
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  4, length=25, piece="rfx", onActive=true, emitVector = {0, 0, 1}}},
	-- },
	-- armpnix = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=25, piece="exhaustl", onActive=true}},
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=25, piece="exhaustr", onActive=true}},
		-- {class='Ribbon',	options={width=1, size=10, piece="wingtipl"}},
		-- {class='Ribbon',	options={width=1, size=10, piece="wingtipr"}},	
	-- },
	-- armthund = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=15, piece="nozzle1", onActive=true}},
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=15, piece="nozzle2", onActive=true}},
	-- },

	-- armdfly = {
		-- {class='AirJet',	options={color={0.1,0.5,0.3},	width =  3.2, length=22, piece="jet1", onActive=true}},
		-- {class='AirJet',	options={color={0.1,0.5,0.3},	width =  3.2, length=22, piece="jet2", onActive=true}},
	-- },

	-- corshad = {
		-- {class='AirJet',	options={color={0.8,0.1,0.0},	width =  4, length=25, piece="thrustr", texture2=":c:bitmaps/gpl/lups/jet2.bmp", onActive=true}},
		-- {class='AirJet',	options={color={0.8,0.1,0.0},	width =  4, length=25, piece="thrustl", texture2=":c:bitmaps/gpl/lups/jet2.bmp", onActive=true}},
	-- },
	-- fighter = {
		-- {class='AirJet',	options={color={0.6,0.1,0.0},	width =  3.5, length=55, piece="nozzle1", texture2=":c:bitmaps/gpl/lups/jet2.bmp", onActive=true}},
		-- {class='AirJet',	options={color={0.6,0.1,0.0},	width =  3.5, length=55, piece="nozzle2", texture2=":c:bitmaps/gpl/lups/jet2.bmp", onActive=true}},
		-- {class='Ribbon',	options={width=1, piece="wingtip1"}},
		-- {class='Ribbon',	options={width=1, piece="wingtip2"}},
	-- },
	-- corape = {
		-- {class='AirJet',	options={color={0.6,0.1,0.0},	width =  3.5, length=22, piece="rthrust1", onActive=true}},
		-- {class='AirJet',	options={color={0.6,0.1,0.0},	width =  3.5, length=22, piece="rthrust2", onActive=true}},
	-- },
	-- corhurc = {
		-- {class='AirJet',	options={color={0.5,0.1,0.0},	width =  3.5, length=25, piece="nozzle1", onActive=true}},
		-- {class='AirJet',	options={color={0.5,0.1,0.0},	width =  3.5, length=25, piece="nozzle2", onActive=true}},
 	-- },
	-- corhurc2 = {
		-- {class='AirJet',	options={color={0.7,0.3,0.1},	width =  3, length=25, piece="exhaustl1", onActive=true}},
		-- {class='AirJet',	options={color={0.7,0.3,0.1},	width =  3, length=25, piece="exhaustr1", onActive=true}},
		-- {class='AirJet',	options={color={0.7,0.3,0.1},	width =  3, length=25, piece="exhaustl2", onActive=true}},
		-- {class='AirJet',	options={color={0.7,0.3,0.1},	width =  3, length=25, piece="exhaustr2", onActive=true}},
		-- {class='Ribbon',	options={width=1, piece="wingtipl"}},
		-- {class='Ribbon',	options={width=1, piece="wingtipr"}},
	-- },
	-- corvamp = {
		-- {class='AirJet',	options={color={0.6,0.1,0.0},	width =  3.5, length=55, piece="thrustb", onActive=true}},
		-- {class='Ribbon',	options={width=1, size=8, piece="wingtipa"}},
		-- {class='Ribbon',	options={width=1, size=8, piece="wingtipb"}},
	-- },
	-- corawac = {
		-- {class='AirJet',	options={color={0.1,0.4,0.6},	width =  3.5, length=25, piece="thrust", onActive=true}},
	-- },
	-- blackdawn = {
		-- {class='AirJet',	options={color={0.8,0.1,0.0},	width =  7, length=30, jitterWidthScale=2, distortion=0.01, piece="Lengine", texture2=":c:bitmaps/gpl/lups/jet2.bmp", onActive=true}},
		-- {class='AirJet',	options={color={0.8,0.1,0.0},	width =  7, length=30, jitterWidthScale=2, distortion=0.01, piece="Rengine", texture2=":c:bitmaps/gpl/lups/jet2.bmp", onActive=true}},
	-- },

	-- corcrw = {
		-- {class='AirJet',	options={color={0.6,0.15,0.0},	width =  4.5, length=20, distortion=0.01, piece="engine", texture2=":c:bitmaps/gpl/lups/jet2.bmp", onActive=true}},

		-- {class='AirJet',	options={color={0.5,0.05,0.0},	width =  3.5, length=19, distortion=0.01, piece="leftengine1", onActive=true}},
		-- {class='AirJet',	options={color={0.5,0.05,0.0},	width =  3.5, length=16, distortion=0.01, piece="leftengine2", onActive=true}},
		-- {class='AirJet',	options={color={0.5,0.05,0.0},	width =  3.5, length=13, distortion=0.01, piece="leftengine3", onActive=true}},

		-- {class='AirJet',	options={color={0.5,0.05,0.0},	width =  3.5, length=19, distortion=0.01, piece="rightengine1", onActive=true}},
		-- {class='AirJet',	options={color={0.5,0.05,0.0},	width =  3.5, length=16, distortion=0.01, piece="rightengine2", onActive=true}},
		-- {class='AirJet',	options={color={0.5,0.05,0.0},	width =  3.5, length=13, distortion=0.01, piece="rightengine3", onActive=true}},
	-- },
 }

effectUnitDefsXmas = {
	-- armcom = {
		-- {class='SantaHat',	options={color={0,0.7,0,1.0}, pos={0,4,0.35}, emitVector={0.3,1.0,0.2},	width =  2.7, height=6, ballSize=0.7, piece="head"}},
	-- },
	-- corcom = {
		-- {class='SantaHat',	options={pos={0,6,2}, emitVector={0.4,1.0,0.2},	width =  2.7, height=6, ballSize=0.7, piece="head"}},
	-- },
}